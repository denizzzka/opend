module audioformats.stream;

import core.stdc.stdio;
import core.stdc.string;
import core.stdc.stdlib: realloc, free;

import dplug.core.nogc;
import dplug.core.vec;

import audioformats: AudioFileFormat;
import audioformats.io;

version(decodeMP3) import audioformats.minimp3;
version(decodeWAV) import audioformats.wav;


/// The length of things you shouldn't query a length about:
///    - files that are being written
///    - audio files you don't know the extent
enum audiostreamUnknownLength = -1;

/// An AudioStream is a pointer to a dynamically allocated `Stream`.
public struct AudioStream
{
public: // This is also part of the public API


    /// Opens an audio stream that decodes from a file.
    /// This stream will be opened for reading only.
    ///
    /// Params: 
    ///     path An UTF-8 path to the sound file.
    ///
    /// Note: throws a manually allocated exception in case of error. Free it with `dplug.core.destroyFree`.
    void openFromFile(const(char)[] path) @nogc
    {
        cleanUp();

        fileContext = mallocNew!FileContext();
        fileContext.initialize(path, false);
        userData = fileContext;

        _io = mallocNew!IOCallbacks();
        _io.seek          = &file_seek;
        _io.tell          = &file_tell;
        _io.getFileLength = &file_getFileLength;
        _io.read          = &file_read;
        _io.write         = null;
        _io.skip          = &file_skip;

        startDecoding();
    }

    /// Opens an audio stream that decodes from memory.
    /// This stream will be opened for reading only.
    /// Note: throws a manually allocated exception in case of error. Free it with `dplug.core.destroyFree`.
    ///
    /// Params: inputData The whole file to decode.
    void openFromMemory(const(ubyte)[] inputData) @nogc
    {
        cleanUp();

        memoryContext = mallocNew!MemoryContext();
        memoryContext.initializeWithConstantInput(inputData.ptr, inputData.length);

        userData = memoryContext;

        _io = mallocNew!IOCallbacks();
        _io.seek          = &memory_seek;
        _io.tell          = &memory_tell;
        _io.getFileLength = &memory_getFileLength;
        _io.read          = &memory_read;
        _io.write         = null;
        _io.skip          = &memory_skip;

        startDecoding();
    }

    /// Opens an audio stream that writes to file.
    /// This stream will be opened for writing only.
    /// Note: throws a manually allocated exception in case of error. Free it with `dplug.core.destroyFree`.
    ///
    /// Params: 
    ///     path An UTF-8 path to the sound file.
    ///     format Audio file format to generate.
    ///     sampleRate Sample rate of this audio stream. This samplerate might be rounded up to the nearest integer number.
    ///     numChannels Number of channels of this audio stream.
    void openToFile(const(char)[] path, AudioFileFormat format, float sampleRate, int numChannels) @nogc
    {
        cleanUp();
        
        fileContext = mallocNew!FileContext();
        fileContext.initialize(path, true);
        userData = fileContext;

        _io = mallocNew!IOCallbacks();
        _io.seek          = &file_seek;
        _io.tell          = &file_tell;
        _io.getFileLength = null;
        _io.read          = null;
        _io.write         = &file_write;
        _io.skip          = null;

        startEncoding(format, sampleRate, numChannels);
    }

    /// Opens an audio stream that writes to a dynamically growable output buffer.
    /// This stream will be opened for writing only.
    /// Access to the internal buffer after encoding with `finalizeAndGetEncodedResult`.
    /// Note: throws a manually allocated exception in case of error. Free it with `dplug.core.destroyFree`.
    ///
    /// Params: 
    ///     format Audio file format to generate.
    ///     sampleRate Sample rate of this audio stream. This samplerate might be rounded up to the nearest integer number.
    ///     numChannels Number of channels of this audio stream.
    void openToBuffer(AudioFileFormat format, float sampleRate, int numChannels) @nogc
    {
        cleanUp();

        memoryContext = mallocNew!MemoryContext();
        memoryContext.initializeWithInternalGrowableBuffer();
        userData = memoryContext;

        _io = mallocNew!IOCallbacks();
        _io.seek          = &memory_seek;
        _io.tell          = &memory_tell;
        _io.getFileLength = null;
        _io.read          = null;
        _io.write         = &memory_write_append;
        _io.skip          = null;

        startEncoding(format, sampleRate, numChannels);
    }

    /// Opens an audio stream that writes to a pre-defined area in memory of `maxLength` bytes.
    /// This stream will be opened for writing only.
    /// Destroy this stream with `closeAudioStream`.
    /// Note: throws a manually allocated exception in case of error. Free it with `dplug.core.destroyFree`.
    ///
    /// Params: 
    ///     data Pointer to output memory.
    ///     size_t maxLength.
    ///     format Audio file format to generate.
    ///     sampleRate Sample rate of this audio stream. This samplerate might be rounded up to the nearest integer number.
    ///     numChannels Number of channels of this audio stream.
    void openToMemory(ubyte* data, 
                      size_t maxLength,
                      AudioFileFormat format,
                      float sampleRate, 
                      int numChannels) @nogc
    {
        cleanUp();

        memoryContext = mallocNew!MemoryContext();
        memoryContext.initializeWithExternalOutputBuffer(data, maxLength);
        userData = memoryContext;

        _io = mallocNew!IOCallbacks();
        _io.seek          = &memory_seek;
        _io.tell          = &memory_tell;
        _io.getFileLength = null;
        _io.read          = null;
        _io.write         = &memory_write_limited;
        _io.skip          = null;

        startEncoding(format, sampleRate, numChannels);
    }

    ~this() @nogc
    {
        cleanUp();
    }

    void cleanUp() @nogc
    {
        // Write the last needed bytes if needed
        finalizeEncoding();

        version(decodeMP3)
        {
            if (_mp3Decoder !is null)
            {
                destroyFree(_mp3Decoder);
                _mp3Decoder = null;
            }
        }

        version(decodeWAV)
        {
            if (_wavDecoder !is null)
            {
                destroyFree(_wavDecoder);
                _wavDecoder = null;
            }
        }

        version(encodeWAV)
        {
            if (_wavEncoder !is null)
            {
                destroyFree(_wavEncoder);
                _wavEncoder = null;
            }
        }

        if (_decoderContext)
        {
            destroyFree(_decoderContext);
            _decoderContext = null;
        }

        if (fileContext !is null)
        {
            if (fileContext.file !is null)
            {
                int result = fclose(fileContext.file);
                if (result)
                    throw mallocNew!Exception("Closing of audio file errored");            
            }
            destroyFree(fileContext);
            fileContext = null;
        }

        if (memoryContext !is null)
        {
            // TODO destroy buffer if any and owned
            destroyFree(memoryContext);
            memoryContext = null;
        }

        if (_io !is null)
        {
            // TODO destroy buffer if any and owned
            destroyFree(_io);
            _io = null;
        }
    }

    /// Returns: File format of this stream.
    AudioFileFormat getFormat() nothrow @nogc
    {
        return _format;
    }

    /// Returns: File format of this stream.
    int getNumChannels() nothrow @nogc
    {
        return _numChannels;
    }

    /// Returns: Length of this stream in frames.
    /// Note: may return `audiostreamUnknownLength` if the length is unknown.
    long getLengthInFrames() nothrow @nogc
    {
        return _lengthInFrames;
    }

    /// Returns: Sample-rate of this stream in Hz.
    float getSamplerate() nothrow @nogc
    {
        return _sampleRate;
    }

    /// Read interleaved float samples.
    /// `outData` must have enough room for `frames` * `channels` decoded samples.
    int readSamplesFloat(float* outData, int frames) @nogc
    {
        final switch(_format)
        {
            case AudioFileFormat.mp3:
            {
                version(decodeMP3)
                {
                    assert(_mp3Decoder !is null);

                    if (!_mp3Decoder.valid)
                        return 0;

                    // Ensure the read buffer is filled with at least `frames` interleaved frames.

                    int samplesNeeded = frames * _numChannels;

                    // Decode MP3 frame until we have `frames` samples or the file is terminated.
                    int read = 0;
                    while ( _mp3Decoder.valid && ( read < samplesNeeded ) ) 
                    {
                        int numDecoded = cast(int)(_mp3Decoder.frameSamples.length);
                        size_t initialLength = _readBuffer.length();
                        _readBuffer.resize(initialLength + numDecoded);
                        float invShortMax = 1.0 / cast(float)(short.max);
                        // Convert to float
                        // TODO is this correct?
                        foreach(n; 0..numDecoded)
                        {
                            import core.stdc.stdio;
                            _readBuffer[initialLength + n] = _mp3Decoder.frameSamples[n] * invShortMax;
                        }
                        read += numDecoded;
                        _mp3Decoder.decodeNextFrame(&mp3ReadDelegate);
                    }

                    if (read >= samplesNeeded)
                    {
                        outData[0..samplesNeeded] = _readBuffer[0..samplesNeeded];
                        int remaining = read - samplesNeeded;
                        if (remaining > 0)
                            memmove(_readBuffer.ptr, &_readBuffer[samplesNeeded], float.sizeof * remaining);
                        _readBuffer.resize(remaining); // Note: Vec should keep that capacity and not free the memory.
                        return frames;
                    }
                    else
                    {
                        // How many sample can we produce?
                        int completeSamples = read / _numChannels;
                        outData[0..completeSamples] = _readBuffer[0..completeSamples];
                        _readBuffer.resize(0);
                        return completeSamples;
                    }
                }
                else
                {
                    assert(false, "no support for MP3 decoding");
                }
            }
            case AudioFileFormat.wav:
                version(decodeWAV)
                {
                    assert(_wavDecoder !is null);
                    return 0;
                }
                else
                {
                    assert(false, "no support for MP3 decoding");
                }

            case AudioFileFormat.unknown:
                // One shouldn't ever get there, since in this case
                // opening has failed.
                assert(false);
        }
    }
    ///ditto
    int readSamplesFloat(float[] outData) @nogc
    {
        return readSamplesFloat(outData.ptr, cast(int)outData.length);
    }

    /// Write interleaved float samples.
    /// `inData` must have enough data for `frames` * `channels` samples.
    int writeSamplesFloat(float* inData, int frames) nothrow @nogc
    {
        assert(false);
    }
    ///ditto
    int writeSamplesFloat(float[] inData) nothrow @nogc
    {
        return writeSamplesFloat(inData.ptr, cast(int)inData.length);
    }

    /// Call `fflush()` on written samples, if any. 
    /// Automatically done by `audiostreamClose`.
    void flush() nothrow @nogc
    {
        // TODO
    }

    // Finalize encoding and get internal buffer.
    const(ubyte)[] finalizeAndGetEncodedResult() @nogc
    {
        // only callable while appending, else it's a programming error
        assert( (memoryContext !is null) && (_io.write == &memory_write_append) );

        finalizeEncoding(); 
        return memoryContext.buffer[0..memoryContext.size];
    }

private:
    IOCallbacks* _io;

    // This type of context is a closure to remember where the data is.
    void* userData; // is equal to either fileContext or memoryContext
    FileContext* fileContext;
    MemoryContext* memoryContext;

    // This type of context is a closure to remember where _io and user Data is.
    DecoderContext* _decoderContext;

    AudioFileFormat _format;
    float _sampleRate; 
    int _numChannels;
    long _lengthInFrames;

    // Decoders
    version(decodeMP3)
    {
        MP3Decoder _mp3Decoder;
        Vec!float _readBuffer;
    }
    version(decodeWAV)
    {
        WAVDecoder _wavDecoder;
    }

    // Encoder
    version(encodeWAV)
    {
        WAVEncoder _wavEncoder;
    }

    bool isOpenedForWriting() nothrow @nogc
    {
        // Note: 
        //  * when opened for reading, I/O operations given are: seek/tell/getFileLength/read.
        //  * when opened for writing, I/O operations given are: seek/tell/write.
        return _io.read is null;
    }

    void startDecoding() @nogc
    {
        // Create a decoder context
        _decoderContext = mallocNew!DecoderContext;
        _decoderContext.userDataIO = userData;
        _decoderContext.callbacks = _io;

        version(decodeWAV)
        {
            // Check if it's a WAV.

            _io.seek(0, userData);

            try
            {
                _wavDecoder = mallocNew!WAVDecoder(_io, userData);
                _wavDecoder.scan();

                // WAV detected
                _format = AudioFileFormat.wav;
                _sampleRate = _wavDecoder._sampleRate;
                _numChannels = _wavDecoder._channels;
                _lengthInFrames = _wavDecoder._lengthInFrames;
                return;
            }
            catch(Exception e)
            {
                // not a WAV
                destroyFree(e);
            }
            destroyFree(_wavDecoder);
        }

        version(decodeMP3)
        {
            // Check if it's a MP3.
            // minimp3 need a delegate

            _io.seek(0, userData);
            
            MP3Info info = mp3Scan(&mp3ReadDelegate, _decoderContext);
       
            if (info.valid)
            {
                // MP3 detected
                _format = AudioFileFormat.mp3;
                _sampleRate = info.sampleRate;
                _numChannels = info.channels;
                _lengthInFrames = info.samples;

                _io.seek(0, userData);
                _mp3Decoder = mallocNew!MP3Decoder(&mp3ReadDelegate, _decoderContext);

                _readBuffer = makeVec!float();

                if (!_mp3Decoder.valid) 
                    throw mallocNew!Exception("invalid MP3 file");

                return;
            }
        }       
    }

    void startEncoding(AudioFileFormat format, float sampleRate, int numChannels) @nogc
    { 
        _format = format;
        _sampleRate = sampleRate;
        _numChannels = numChannels;

        final switch(format) with (AudioFileFormat)
        {
            case mp3:
                throw mallocNew!Exception("Unsupported encoding format: MP3");
            case wav:
            {
                // Note: fractional sample rates not supported by WAV, signal an integer one
                int isampleRate = cast(int)(sampleRate + 0.5f);
                _wavEncoder = mallocNew!WAVEncoder(_io, userData, isampleRate, numChannels );
                break;
            }
            case unknown:
                throw mallocNew!Exception("Can't encode using 'unknown' coding");
        }        
    }

    void finalizeEncoding() @nogc 
    {
        if (_io.write !is null)
        {
            _io.write = null;
            final switch(_format) with (AudioFileFormat)
            {
                case mp3:
                    assert(false);
                case wav:
                    { 
                        _wavEncoder.finalizeEncoding();
                        break;
                    }
                case unknown:
                    assert(false);
            }
        }
    }

}

private: // not meant to be imported at all



// Internal object for audio-formats




// File callbacks
// The file callbacks are using the C stdlib.

struct FileContext // this is what is passed to I/O when used in file mode
{
    // Used when streaming of writing a file
    FILE* file = null;

    // Size of the file in bytes, only used when reading/writing a file.
    long fileSize;

    // Initialize this context
    void initialize(const(char)[] path, bool forWrite) @nogc
    {
        CString strZ = CString(path);
        file = fopen(strZ.storage, forWrite ? "wb".ptr : "rb".ptr);

        // finds the size of the file
        fseek(file, 0, SEEK_END);
        fileSize = ftell(file);
        fseek(file, 0, SEEK_SET);
    }
}

long file_tell(void* userData) nothrow @nogc
{
    FileContext* context = cast(FileContext*)userData;
    return ftell(context.file);
}

void file_seek(long offset, void* userData) nothrow @nogc
{
    FileContext* context = cast(FileContext*)userData;
    assert(offset <= int.max);
    fseek(context.file, cast(int)offset, SEEK_SET); // Limitations: file larger than 2gb not supported
}

long file_getFileLength(void* userData) nothrow @nogc
{
    FileContext* context = cast(FileContext*)userData;
    return context.fileSize;
}

int file_read(void* outData, int bytes, void* userData) nothrow @nogc
{
    FileContext* context = cast(FileContext*)userData;
    size_t bytesRead = fread(outData, 1, bytes, context.file);
    return cast(int)bytesRead;
}

int file_write(void* inData, int bytes, void* userData) nothrow @nogc
{
    FileContext* context = cast(FileContext*)userData;
    size_t bytesWritten = fwrite(inData, 1, bytes, context.file);
    return cast(int)bytesWritten;
}

bool file_skip(int bytes, void* userData) nothrow @nogc
{
    FileContext* context = cast(FileContext*)userData;
    return (0 == fseek(context.file, bytes, SEEK_CUR));
}

// Memory read callback
// Using the read buffer instead

struct MemoryContext
{
    bool bufferIsOwned;

    // Buffer
    ubyte* buffer = null;

    size_t size;     // current buffer size
    size_t cursor;   // where we are in the buffer
    size_t capacity; // max buffer size before realloc

    void initializeWithConstantInput(const(ubyte)* data, size_t length) nothrow @nogc
    {
        // Make a copy of the input buffer, since it could be temporary.
        bufferIsOwned = true;

        buffer = mallocDup(data[0..length]).ptr; // Note: the copied slice is made mutable.
        size = length;
        cursor = 0;
        capacity = length;
    }

    void initializeWithExternalOutputBuffer(ubyte* data, size_t length) nothrow @nogc
    {
        bufferIsOwned = false;
        buffer = data;
        size = length;
        cursor = 0;
        capacity = length;
    }

    void initializeWithInternalGrowableBuffer() nothrow @nogc
    {
        bufferIsOwned = true;
        buffer = null;
        size = 0;
        cursor = 0;
        capacity = 0;
    }

    ~this()
    {
        if (bufferIsOwned)
        {
            if (buffer !is null)
            {
                free(buffer);
                buffer = null;
            }
        }
    }
}

long memory_tell(void* userData) nothrow @nogc
{
    MemoryContext* context = cast(MemoryContext*)userData;
    return cast(long)(context.cursor);
}

void memory_seek(long offset, void* userData) nothrow @nogc
{
    MemoryContext* context = cast(MemoryContext*)userData;
    if (offset >= context.size) // can't seek past end of buffer, stick to the end so that read return 0 byte
        offset = context.size;
    context.cursor = cast(size_t)offset; // Note: memory streams larger than 2gb not supported
}

long memory_getFileLength(void* userData) nothrow @nogc
{
    MemoryContext* context = cast(MemoryContext*)userData;
    return cast(long)(context.size);
}

int memory_read(void* outData, int bytes, void* userData) nothrow @nogc
{
    MemoryContext* context = cast(MemoryContext*)userData;
    size_t cursor = context.cursor;
    size_t size = context.size;
    size_t available = size - cursor;
    if (bytes < available)
    {
        outData[0..bytes] = context.buffer[cursor..cursor + bytes];
        context.cursor += bytes;
        return bytes;
    }
    else
    {
        outData[0..available] = context.buffer[cursor..cursor + available];
        context.cursor = context.size;
        return cast(int)available;
    }
}

int memory_write_limited(void* inData, int bytes, void* userData) nothrow @nogc
{
    MemoryContext* context = cast(MemoryContext*)userData;
    size_t cursor = context.cursor;
    size_t size = context.size;
    size_t available = size - cursor;
    ubyte* buffer = context.buffer;
    ubyte* source = cast(ubyte*) inData;

    if (cursor + bytes > available)
    {
        bytes = cast(int)(available - cursor);       
    }

    buffer[cursor..(cursor + bytes)] = source[0..bytes];
    context.size += bytes;
    context.cursor += bytes;
    return bytes;
}

int memory_write_append(void* inData, int bytes, void* userData) nothrow @nogc
{
    MemoryContext* context = cast(MemoryContext*)userData;
    size_t cursor = context.cursor;
    size_t size = context.size;
    size_t available = size - cursor;
    ubyte* buffer = context.buffer;
    ubyte* source = cast(ubyte*) inData;

    if (cursor + bytes > available)
    {
        size_t oldSize = context.capacity;
        size_t newSize = cursor + bytes;
        if (newSize < oldSize * 2 + 1) 
            newSize = oldSize * 2 + 1;
        buffer = cast(ubyte*) realloc(buffer, newSize);
        context.capacity = newSize;

        assert( cursor + bytes <= available );
    }

    buffer[cursor..(cursor + bytes)] = source[0..bytes];
    context.size += bytes;
    context.cursor += bytes;
    return bytes;
}

bool memory_skip(int bytes, void* userData) nothrow @nogc
{
    MemoryContext* context = cast(MemoryContext*)userData;
    context.cursor += bytes;
    return context.cursor <= context.size;
}


// Decoder context
struct DecoderContext
{
    void* userDataIO;
    IOCallbacks* callbacks;
}


static int mp3ReadDelegate(void[] buf, void* userDataDecoder) @nogc nothrow
{
    DecoderContext* context = cast(DecoderContext*) userDataDecoder;

    // read bytes into the buffer, return number of bytes read or 0 for EOF, -1 on error
    // will never be called with empty buffer, or buffer more than 128KB

    int bytes = context.callbacks.read(buf.ptr, cast(int)(buf.length), context.userDataIO);
    return bytes;
}