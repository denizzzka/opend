/**
 * Dlang vulkan platform specific types and functions as mixin template
 *
 * Copyright: Copyright 2015-2016 The Khronos Group Inc.; Copyright 2016 Alex Parrill, Peter Particle.
 * License:   $(https://opensource.org/licenses/MIT, MIT License).
 * Authors: Copyright 2016 Alex Parrill, Peter Particle
 */
module erupted.platform_extensions;

/// define platform extension names as enums
/// these enums can be used directly in Platform_Extensions mixin template
enum KHR_xlib_surface;
enum KHR_xcb_surface;
enum KHR_wayland_surface;
enum KHR_android_surface;
enum KHR_win32_surface;
enum KHR_external_memory_win32;
enum KHR_win32_keyed_mutex;
enum KHR_external_semaphore_win32;
enum KHR_external_fence_win32;
enum KHR_portability_subset;
enum KHR_video_encode_queue;
enum EXT_video_encode_h264;
enum EXT_video_encode_h265;
enum GGP_stream_descriptor_surface;
enum NV_external_memory_win32;
enum NV_win32_keyed_mutex;
enum NN_vi_surface;
enum EXT_acquire_xlib_display;
enum MVK_ios_surface;
enum MVK_macos_surface;
enum ANDROID_external_memory_android_hardware_buffer;
enum GGP_frame_token;
enum FUCHSIA_imagepipe_surface;
enum EXT_metal_surface;
enum EXT_full_screen_exclusive;
enum EXT_metal_objects;
enum NV_acquire_winrt_display;
enum EXT_directfb_surface;
enum FUCHSIA_external_memory;
enum FUCHSIA_external_semaphore;
enum FUCHSIA_buffer_collection;
enum QNX_screen_surface;
enum NV_displacement_micromap;


/// extensions to a specific platform are grouped in these enum sequences
import std.meta : AliasSeq;
alias USE_PLATFORM_XLIB_KHR        = AliasSeq!( KHR_xlib_surface );
alias USE_PLATFORM_XCB_KHR         = AliasSeq!( KHR_xcb_surface );
alias USE_PLATFORM_WAYLAND_KHR     = AliasSeq!( KHR_wayland_surface );
alias USE_PLATFORM_ANDROID_KHR     = AliasSeq!( KHR_android_surface, ANDROID_external_memory_android_hardware_buffer );
alias USE_PLATFORM_WIN32_KHR       = AliasSeq!( KHR_win32_surface, KHR_external_memory_win32, KHR_win32_keyed_mutex, KHR_external_semaphore_win32, KHR_external_fence_win32, NV_external_memory_win32, NV_win32_keyed_mutex, EXT_full_screen_exclusive, NV_acquire_winrt_display );
alias ENABLE_BETA_EXTENSIONS       = AliasSeq!( KHR_portability_subset, KHR_video_encode_queue, EXT_video_encode_h264, EXT_video_encode_h265, NV_displacement_micromap );
alias USE_PLATFORM_GGP             = AliasSeq!( GGP_stream_descriptor_surface, GGP_frame_token );
alias USE_PLATFORM_VI_NN           = AliasSeq!( NN_vi_surface );
alias USE_PLATFORM_XLIB_XRANDR_EXT = AliasSeq!( EXT_acquire_xlib_display );
alias USE_PLATFORM_IOS_MVK         = AliasSeq!( MVK_ios_surface );
alias USE_PLATFORM_MACOS_MVK       = AliasSeq!( MVK_macos_surface );
alias USE_PLATFORM_FUCHSIA         = AliasSeq!( FUCHSIA_imagepipe_surface, FUCHSIA_external_memory, FUCHSIA_external_semaphore, FUCHSIA_buffer_collection );
alias USE_PLATFORM_METAL_EXT       = AliasSeq!( EXT_metal_surface, EXT_metal_objects );
alias USE_PLATFORM_DIRECTFB_EXT    = AliasSeq!( EXT_directfb_surface );
alias USE_PLATFORM_SCREEN_QNX      = AliasSeq!( QNX_screen_surface );



/// instantiate platform and extension specific code with this mixin template
/// required types and data structures must be imported into the module where
/// this template is instantiated
mixin template Platform_Extensions( extensions... ) {

    // publicly import erupted package modules
    public import erupted.types;
    public import erupted.functions;
    import erupted.dispatch_device;

    // mixin function linkage, nothrow and @nogc attributes for subsecuent functions
    extern(System) nothrow @nogc:

    // remove duplicates from alias sequence
    // this might happen if a platform extension collection AND a single extension, which is included in the collection, was specified
    // e.g.: mixin Platform_Extensions!( VK_USE_PLATFORM_WIN32_KHR, VK_KHR_external_memory_win32 );
    import std.meta : NoDuplicates;
    alias noDuplicateExtensions = NoDuplicates!extensions;

    // 1. loop through alias sequence and mixin corresponding
    // extension types, aliased function pointer type definitions and __gshared function pointer declarations
    static foreach( extension; noDuplicateExtensions ) {

        // VK_KHR_xlib_surface : types and function pointer type aliases
        static if( __traits( isSame, extension, KHR_xlib_surface )) {
            enum VK_KHR_xlib_surface = 1;

            enum VK_KHR_XLIB_SURFACE_SPEC_VERSION = 6;
            enum const( char )* VK_KHR_XLIB_SURFACE_EXTENSION_NAME = "VK_KHR_xlib_surface";
            
            alias VkXlibSurfaceCreateFlagsKHR = VkFlags;
            
            struct VkXlibSurfaceCreateInfoKHR {
                VkStructureType              sType = VK_STRUCTURE_TYPE_XLIB_SURFACE_CREATE_INFO_KHR;
                const( void )*               pNext;
                VkXlibSurfaceCreateFlagsKHR  flags;
                Display*                     dpy;
                Window                       window;
            }
            
            alias PFN_vkCreateXlibSurfaceKHR                                            = VkResult  function( VkInstance instance, const( VkXlibSurfaceCreateInfoKHR )* pCreateInfo, const( VkAllocationCallbacks )* pAllocator, VkSurfaceKHR* pSurface );
            alias PFN_vkGetPhysicalDeviceXlibPresentationSupportKHR                     = VkBool32  function( VkPhysicalDevice physicalDevice, uint32_t queueFamilyIndex, Display* dpy, VisualID visualID );
        }

        // VK_KHR_xcb_surface : types and function pointer type aliases
        else static if( __traits( isSame, extension, KHR_xcb_surface )) {
            enum VK_KHR_xcb_surface = 1;

            enum VK_KHR_XCB_SURFACE_SPEC_VERSION = 6;
            enum const( char )* VK_KHR_XCB_SURFACE_EXTENSION_NAME = "VK_KHR_xcb_surface";
            
            alias VkXcbSurfaceCreateFlagsKHR = VkFlags;
            
            struct VkXcbSurfaceCreateInfoKHR {
                VkStructureType             sType = VK_STRUCTURE_TYPE_XCB_SURFACE_CREATE_INFO_KHR;
                const( void )*              pNext;
                VkXcbSurfaceCreateFlagsKHR  flags;
                xcb_connection_t*           connection;
                xcb_window_t                window;
            }
            
            alias PFN_vkCreateXcbSurfaceKHR                                             = VkResult  function( VkInstance instance, const( VkXcbSurfaceCreateInfoKHR )* pCreateInfo, const( VkAllocationCallbacks )* pAllocator, VkSurfaceKHR* pSurface );
            alias PFN_vkGetPhysicalDeviceXcbPresentationSupportKHR                      = VkBool32  function( VkPhysicalDevice physicalDevice, uint32_t queueFamilyIndex, xcb_connection_t* connection, xcb_visualid_t visual_id );
        }

        // VK_KHR_wayland_surface : types and function pointer type aliases
        else static if( __traits( isSame, extension, KHR_wayland_surface )) {
            enum VK_KHR_wayland_surface = 1;

            enum VK_KHR_WAYLAND_SURFACE_SPEC_VERSION = 6;
            enum const( char )* VK_KHR_WAYLAND_SURFACE_EXTENSION_NAME = "VK_KHR_wayland_surface";
            
            alias VkWaylandSurfaceCreateFlagsKHR = VkFlags;
            
            struct VkWaylandSurfaceCreateInfoKHR {
                VkStructureType                 sType = VK_STRUCTURE_TYPE_WAYLAND_SURFACE_CREATE_INFO_KHR;
                const( void )*                  pNext;
                VkWaylandSurfaceCreateFlagsKHR  flags;
                const( wl_display )*            display;
                const( wl_surface )*            surface;
            }
            
            alias PFN_vkCreateWaylandSurfaceKHR                                         = VkResult  function( VkInstance instance, const( VkWaylandSurfaceCreateInfoKHR )* pCreateInfo, const( VkAllocationCallbacks )* pAllocator, VkSurfaceKHR* pSurface );
            alias PFN_vkGetPhysicalDeviceWaylandPresentationSupportKHR                  = VkBool32  function( VkPhysicalDevice physicalDevice, uint32_t queueFamilyIndex, const( wl_display )* display );
        }

        // VK_KHR_android_surface : types and function pointer type aliases
        else static if( __traits( isSame, extension, KHR_android_surface )) {
            enum VK_KHR_android_surface = 1;

            enum VK_KHR_ANDROID_SURFACE_SPEC_VERSION = 6;
            enum const( char )* VK_KHR_ANDROID_SURFACE_EXTENSION_NAME = "VK_KHR_android_surface";
            
            alias VkAndroidSurfaceCreateFlagsKHR = VkFlags;
            
            struct VkAndroidSurfaceCreateInfoKHR {
                VkStructureType                 sType = VK_STRUCTURE_TYPE_ANDROID_SURFACE_CREATE_INFO_KHR;
                const( void )*                  pNext;
                VkAndroidSurfaceCreateFlagsKHR  flags;
                const( ANativeWindow )*         window;
            }
            
            alias PFN_vkCreateAndroidSurfaceKHR                                         = VkResult  function( VkInstance instance, const( VkAndroidSurfaceCreateInfoKHR )* pCreateInfo, const( VkAllocationCallbacks )* pAllocator, VkSurfaceKHR* pSurface );
        }

        // VK_KHR_win32_surface : types and function pointer type aliases
        else static if( __traits( isSame, extension, KHR_win32_surface )) {
            enum VK_KHR_win32_surface = 1;

            enum VK_KHR_WIN32_SURFACE_SPEC_VERSION = 6;
            enum const( char )* VK_KHR_WIN32_SURFACE_EXTENSION_NAME = "VK_KHR_win32_surface";
            
            alias VkWin32SurfaceCreateFlagsKHR = VkFlags;
            
            struct VkWin32SurfaceCreateInfoKHR {
                VkStructureType               sType = VK_STRUCTURE_TYPE_WIN32_SURFACE_CREATE_INFO_KHR;
                const( void )*                pNext;
                VkWin32SurfaceCreateFlagsKHR  flags;
                HINSTANCE                     hinstance;
                HWND                          hwnd;
            }
            
            alias PFN_vkCreateWin32SurfaceKHR                                           = VkResult  function( VkInstance instance, const( VkWin32SurfaceCreateInfoKHR )* pCreateInfo, const( VkAllocationCallbacks )* pAllocator, VkSurfaceKHR* pSurface );
            alias PFN_vkGetPhysicalDeviceWin32PresentationSupportKHR                    = VkBool32  function( VkPhysicalDevice physicalDevice, uint32_t queueFamilyIndex );
        }

        // VK_KHR_external_memory_win32 : types and function pointer type aliases
        else static if( __traits( isSame, extension, KHR_external_memory_win32 )) {
            enum VK_KHR_external_memory_win32 = 1;

            enum VK_KHR_EXTERNAL_MEMORY_WIN32_SPEC_VERSION = 1;
            enum const( char )* VK_KHR_EXTERNAL_MEMORY_WIN32_EXTENSION_NAME = "VK_KHR_external_memory_win32";
            
            struct VkImportMemoryWin32HandleInfoKHR {
                VkStructureType                     sType = VK_STRUCTURE_TYPE_IMPORT_MEMORY_WIN32_HANDLE_INFO_KHR;
                const( void )*                      pNext;
                VkExternalMemoryHandleTypeFlagBits  handleType;
                HANDLE                              handle;
                LPCWSTR                             name;
            }
            
            struct VkExportMemoryWin32HandleInfoKHR {
                VkStructureType                sType = VK_STRUCTURE_TYPE_EXPORT_MEMORY_WIN32_HANDLE_INFO_KHR;
                const( void )*                 pNext;
                const( SECURITY_ATTRIBUTES )*  pAttributes;
                DWORD                          dwAccess;
                LPCWSTR                        name;
            }
            
            struct VkMemoryWin32HandlePropertiesKHR {
                VkStructureType  sType = VK_STRUCTURE_TYPE_MEMORY_WIN32_HANDLE_PROPERTIES_KHR;
                void*            pNext;
                uint32_t         memoryTypeBits;
            }
            
            struct VkMemoryGetWin32HandleInfoKHR {
                VkStructureType                     sType = VK_STRUCTURE_TYPE_MEMORY_GET_WIN32_HANDLE_INFO_KHR;
                const( void )*                      pNext;
                VkDeviceMemory                      memory;
                VkExternalMemoryHandleTypeFlagBits  handleType;
            }
            
            alias PFN_vkGetMemoryWin32HandleKHR                                         = VkResult  function( VkDevice device, const( VkMemoryGetWin32HandleInfoKHR )* pGetWin32HandleInfo, HANDLE* pHandle );
            alias PFN_vkGetMemoryWin32HandlePropertiesKHR                               = VkResult  function( VkDevice device, VkExternalMemoryHandleTypeFlagBits handleType, HANDLE handle, VkMemoryWin32HandlePropertiesKHR* pMemoryWin32HandleProperties );
        }

        // VK_KHR_win32_keyed_mutex : types and function pointer type aliases
        else static if( __traits( isSame, extension, KHR_win32_keyed_mutex )) {
            enum VK_KHR_win32_keyed_mutex = 1;

            enum VK_KHR_WIN32_KEYED_MUTEX_SPEC_VERSION = 1;
            enum const( char )* VK_KHR_WIN32_KEYED_MUTEX_EXTENSION_NAME = "VK_KHR_win32_keyed_mutex";
            
            struct VkWin32KeyedMutexAcquireReleaseInfoKHR {
                VkStructureType           sType = VK_STRUCTURE_TYPE_WIN32_KEYED_MUTEX_ACQUIRE_RELEASE_INFO_KHR;
                const( void )*            pNext;
                uint32_t                  acquireCount;
                const( VkDeviceMemory )*  pAcquireSyncs;
                const( uint64_t )*        pAcquireKeys;
                const( uint32_t )*        pAcquireTimeouts;
                uint32_t                  releaseCount;
                const( VkDeviceMemory )*  pReleaseSyncs;
                const( uint64_t )*        pReleaseKeys;
            }
            
        }

        // VK_KHR_external_semaphore_win32 : types and function pointer type aliases
        else static if( __traits( isSame, extension, KHR_external_semaphore_win32 )) {
            enum VK_KHR_external_semaphore_win32 = 1;

            enum VK_KHR_EXTERNAL_SEMAPHORE_WIN32_SPEC_VERSION = 1;
            enum const( char )* VK_KHR_EXTERNAL_SEMAPHORE_WIN32_EXTENSION_NAME = "VK_KHR_external_semaphore_win32";
            
            struct VkImportSemaphoreWin32HandleInfoKHR {
                VkStructureType                        sType = VK_STRUCTURE_TYPE_IMPORT_SEMAPHORE_WIN32_HANDLE_INFO_KHR;
                const( void )*                         pNext;
                VkSemaphore                            semaphore;
                VkSemaphoreImportFlags                 flags;
                VkExternalSemaphoreHandleTypeFlagBits  handleType;
                HANDLE                                 handle;
                LPCWSTR                                name;
            }
            
            struct VkExportSemaphoreWin32HandleInfoKHR {
                VkStructureType                sType = VK_STRUCTURE_TYPE_EXPORT_SEMAPHORE_WIN32_HANDLE_INFO_KHR;
                const( void )*                 pNext;
                const( SECURITY_ATTRIBUTES )*  pAttributes;
                DWORD                          dwAccess;
                LPCWSTR                        name;
            }
            
            struct VkD3D12FenceSubmitInfoKHR {
                VkStructureType     sType = VK_STRUCTURE_TYPE_D3D12_FENCE_SUBMIT_INFO_KHR;
                const( void )*      pNext;
                uint32_t            waitSemaphoreValuesCount;
                const( uint64_t )*  pWaitSemaphoreValues;
                uint32_t            signalSemaphoreValuesCount;
                const( uint64_t )*  pSignalSemaphoreValues;
            }
            
            struct VkSemaphoreGetWin32HandleInfoKHR {
                VkStructureType                        sType = VK_STRUCTURE_TYPE_SEMAPHORE_GET_WIN32_HANDLE_INFO_KHR;
                const( void )*                         pNext;
                VkSemaphore                            semaphore;
                VkExternalSemaphoreHandleTypeFlagBits  handleType;
            }
            
            alias PFN_vkImportSemaphoreWin32HandleKHR                                   = VkResult  function( VkDevice device, const( VkImportSemaphoreWin32HandleInfoKHR )* pImportSemaphoreWin32HandleInfo );
            alias PFN_vkGetSemaphoreWin32HandleKHR                                      = VkResult  function( VkDevice device, const( VkSemaphoreGetWin32HandleInfoKHR )* pGetWin32HandleInfo, HANDLE* pHandle );
        }

        // VK_KHR_external_fence_win32 : types and function pointer type aliases
        else static if( __traits( isSame, extension, KHR_external_fence_win32 )) {
            enum VK_KHR_external_fence_win32 = 1;

            enum VK_KHR_EXTERNAL_FENCE_WIN32_SPEC_VERSION = 1;
            enum const( char )* VK_KHR_EXTERNAL_FENCE_WIN32_EXTENSION_NAME = "VK_KHR_external_fence_win32";
            
            struct VkImportFenceWin32HandleInfoKHR {
                VkStructureType                    sType = VK_STRUCTURE_TYPE_IMPORT_FENCE_WIN32_HANDLE_INFO_KHR;
                const( void )*                     pNext;
                VkFence                            fence;
                VkFenceImportFlags                 flags;
                VkExternalFenceHandleTypeFlagBits  handleType;
                HANDLE                             handle;
                LPCWSTR                            name;
            }
            
            struct VkExportFenceWin32HandleInfoKHR {
                VkStructureType                sType = VK_STRUCTURE_TYPE_EXPORT_FENCE_WIN32_HANDLE_INFO_KHR;
                const( void )*                 pNext;
                const( SECURITY_ATTRIBUTES )*  pAttributes;
                DWORD                          dwAccess;
                LPCWSTR                        name;
            }
            
            struct VkFenceGetWin32HandleInfoKHR {
                VkStructureType                    sType = VK_STRUCTURE_TYPE_FENCE_GET_WIN32_HANDLE_INFO_KHR;
                const( void )*                     pNext;
                VkFence                            fence;
                VkExternalFenceHandleTypeFlagBits  handleType;
            }
            
            alias PFN_vkImportFenceWin32HandleKHR                                       = VkResult  function( VkDevice device, const( VkImportFenceWin32HandleInfoKHR )* pImportFenceWin32HandleInfo );
            alias PFN_vkGetFenceWin32HandleKHR                                          = VkResult  function( VkDevice device, const( VkFenceGetWin32HandleInfoKHR )* pGetWin32HandleInfo, HANDLE* pHandle );
        }

        // VK_KHR_portability_subset : types and function pointer type aliases
        else static if( __traits( isSame, extension, KHR_portability_subset )) {
            enum VK_KHR_portability_subset = 1;

            enum VK_KHR_PORTABILITY_SUBSET_SPEC_VERSION = 1;
            enum const( char )* VK_KHR_PORTABILITY_SUBSET_EXTENSION_NAME = "VK_KHR_portability_subset";
            
            struct VkPhysicalDevicePortabilitySubsetFeaturesKHR {
                VkStructureType  sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PORTABILITY_SUBSET_FEATURES_KHR;
                void*            pNext;
                VkBool32         constantAlphaColorBlendFactors;
                VkBool32         events;
                VkBool32         imageViewFormatReinterpretation;
                VkBool32         imageViewFormatSwizzle;
                VkBool32         imageView2DOn3DImage;
                VkBool32         multisampleArrayImage;
                VkBool32         mutableComparisonSamplers;
                VkBool32         pointPolygons;
                VkBool32         samplerMipLodBias;
                VkBool32         separateStencilMaskRef;
                VkBool32         shaderSampleRateInterpolationFunctions;
                VkBool32         tessellationIsolines;
                VkBool32         tessellationPointMode;
                VkBool32         triangleFans;
                VkBool32         vertexAttributeAccessBeyondStride;
            }
            
            struct VkPhysicalDevicePortabilitySubsetPropertiesKHR {
                VkStructureType  sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PORTABILITY_SUBSET_PROPERTIES_KHR;
                void*            pNext;
                uint32_t         minVertexInputBindingStrideAlignment;
            }
            
        }

        // VK_KHR_video_encode_queue : types and function pointer type aliases
        else static if( __traits( isSame, extension, KHR_video_encode_queue )) {
            enum VK_KHR_video_encode_queue = 1;

            enum VK_KHR_VIDEO_ENCODE_QUEUE_SPEC_VERSION = 8;
            enum const( char )* VK_KHR_VIDEO_ENCODE_QUEUE_EXTENSION_NAME = "VK_KHR_video_encode_queue";
            
            enum VkVideoEncodeTuningModeKHR {
                VK_VIDEO_ENCODE_TUNING_MODE_DEFAULT_KHR              = 0,
                VK_VIDEO_ENCODE_TUNING_MODE_HIGH_QUALITY_KHR         = 1,
                VK_VIDEO_ENCODE_TUNING_MODE_LOW_LATENCY_KHR          = 2,
                VK_VIDEO_ENCODE_TUNING_MODE_ULTRA_LOW_LATENCY_KHR    = 3,
                VK_VIDEO_ENCODE_TUNING_MODE_LOSSLESS_KHR             = 4,
                VK_VIDEO_ENCODE_TUNING_MODE_MAX_ENUM_KHR             = 0x7FFFFFFF
            }
            
            enum VK_VIDEO_ENCODE_TUNING_MODE_DEFAULT_KHR             = VkVideoEncodeTuningModeKHR.VK_VIDEO_ENCODE_TUNING_MODE_DEFAULT_KHR;
            enum VK_VIDEO_ENCODE_TUNING_MODE_HIGH_QUALITY_KHR        = VkVideoEncodeTuningModeKHR.VK_VIDEO_ENCODE_TUNING_MODE_HIGH_QUALITY_KHR;
            enum VK_VIDEO_ENCODE_TUNING_MODE_LOW_LATENCY_KHR         = VkVideoEncodeTuningModeKHR.VK_VIDEO_ENCODE_TUNING_MODE_LOW_LATENCY_KHR;
            enum VK_VIDEO_ENCODE_TUNING_MODE_ULTRA_LOW_LATENCY_KHR   = VkVideoEncodeTuningModeKHR.VK_VIDEO_ENCODE_TUNING_MODE_ULTRA_LOW_LATENCY_KHR;
            enum VK_VIDEO_ENCODE_TUNING_MODE_LOSSLESS_KHR            = VkVideoEncodeTuningModeKHR.VK_VIDEO_ENCODE_TUNING_MODE_LOSSLESS_KHR;
            enum VK_VIDEO_ENCODE_TUNING_MODE_MAX_ENUM_KHR            = VkVideoEncodeTuningModeKHR.VK_VIDEO_ENCODE_TUNING_MODE_MAX_ENUM_KHR;
            
            alias VkVideoEncodeFlagsKHR = VkFlags;
            
            alias VkVideoEncodeCapabilityFlagsKHR = VkFlags;
            enum VkVideoEncodeCapabilityFlagBitsKHR : VkVideoEncodeCapabilityFlagsKHR {
                VK_VIDEO_ENCODE_CAPABILITY_PRECEDING_EXTERNALLY_ENCODED_BYTES_BIT_KHR        = 0x00000001,
                VK_VIDEO_ENCODE_CAPABILITY_FLAG_BITS_MAX_ENUM_KHR                            = 0x7FFFFFFF
            }
            
            enum VK_VIDEO_ENCODE_CAPABILITY_PRECEDING_EXTERNALLY_ENCODED_BYTES_BIT_KHR       = VkVideoEncodeCapabilityFlagBitsKHR.VK_VIDEO_ENCODE_CAPABILITY_PRECEDING_EXTERNALLY_ENCODED_BYTES_BIT_KHR;
            enum VK_VIDEO_ENCODE_CAPABILITY_FLAG_BITS_MAX_ENUM_KHR                           = VkVideoEncodeCapabilityFlagBitsKHR.VK_VIDEO_ENCODE_CAPABILITY_FLAG_BITS_MAX_ENUM_KHR;
            
            alias VkVideoEncodeRateControlModeFlagsKHR = VkFlags;
            enum VkVideoEncodeRateControlModeFlagBitsKHR : VkVideoEncodeRateControlModeFlagsKHR {
                VK_VIDEO_ENCODE_RATE_CONTROL_MODE_DEFAULT_KHR        = 0,
                VK_VIDEO_ENCODE_RATE_CONTROL_MODE_DISABLED_BIT_KHR   = 0x00000001,
                VK_VIDEO_ENCODE_RATE_CONTROL_MODE_CBR_BIT_KHR        = 0x00000002,
                VK_VIDEO_ENCODE_RATE_CONTROL_MODE_VBR_BIT_KHR        = 0x00000004,
                VK_VIDEO_ENCODE_RATE_CONTROL_MODE_FLAG_BITS_MAX_ENUM_KHR = 0x7FFFFFFF
            }
            
            enum VK_VIDEO_ENCODE_RATE_CONTROL_MODE_DEFAULT_KHR       = VkVideoEncodeRateControlModeFlagBitsKHR.VK_VIDEO_ENCODE_RATE_CONTROL_MODE_DEFAULT_KHR;
            enum VK_VIDEO_ENCODE_RATE_CONTROL_MODE_DISABLED_BIT_KHR  = VkVideoEncodeRateControlModeFlagBitsKHR.VK_VIDEO_ENCODE_RATE_CONTROL_MODE_DISABLED_BIT_KHR;
            enum VK_VIDEO_ENCODE_RATE_CONTROL_MODE_CBR_BIT_KHR       = VkVideoEncodeRateControlModeFlagBitsKHR.VK_VIDEO_ENCODE_RATE_CONTROL_MODE_CBR_BIT_KHR;
            enum VK_VIDEO_ENCODE_RATE_CONTROL_MODE_VBR_BIT_KHR       = VkVideoEncodeRateControlModeFlagBitsKHR.VK_VIDEO_ENCODE_RATE_CONTROL_MODE_VBR_BIT_KHR;
            enum VK_VIDEO_ENCODE_RATE_CONTROL_MODE_FLAG_BITS_MAX_ENUM_KHR = VkVideoEncodeRateControlModeFlagBitsKHR.VK_VIDEO_ENCODE_RATE_CONTROL_MODE_FLAG_BITS_MAX_ENUM_KHR;
            
            alias VkVideoEncodeFeedbackFlagsKHR = VkFlags;
            enum VkVideoEncodeFeedbackFlagBitsKHR : VkVideoEncodeFeedbackFlagsKHR {
                VK_VIDEO_ENCODE_FEEDBACK_BITSTREAM_BUFFER_OFFSET_BIT_KHR     = 0x00000001,
                VK_VIDEO_ENCODE_FEEDBACK_BITSTREAM_BYTES_WRITTEN_BIT_KHR     = 0x00000002,
                VK_VIDEO_ENCODE_FEEDBACK_FLAG_BITS_MAX_ENUM_KHR              = 0x7FFFFFFF
            }
            
            enum VK_VIDEO_ENCODE_FEEDBACK_BITSTREAM_BUFFER_OFFSET_BIT_KHR    = VkVideoEncodeFeedbackFlagBitsKHR.VK_VIDEO_ENCODE_FEEDBACK_BITSTREAM_BUFFER_OFFSET_BIT_KHR;
            enum VK_VIDEO_ENCODE_FEEDBACK_BITSTREAM_BYTES_WRITTEN_BIT_KHR    = VkVideoEncodeFeedbackFlagBitsKHR.VK_VIDEO_ENCODE_FEEDBACK_BITSTREAM_BYTES_WRITTEN_BIT_KHR;
            enum VK_VIDEO_ENCODE_FEEDBACK_FLAG_BITS_MAX_ENUM_KHR             = VkVideoEncodeFeedbackFlagBitsKHR.VK_VIDEO_ENCODE_FEEDBACK_FLAG_BITS_MAX_ENUM_KHR;
            
            alias VkVideoEncodeUsageFlagsKHR = VkFlags;
            enum VkVideoEncodeUsageFlagBitsKHR : VkVideoEncodeUsageFlagsKHR {
                VK_VIDEO_ENCODE_USAGE_DEFAULT_KHR            = 0,
                VK_VIDEO_ENCODE_USAGE_TRANSCODING_BIT_KHR    = 0x00000001,
                VK_VIDEO_ENCODE_USAGE_STREAMING_BIT_KHR      = 0x00000002,
                VK_VIDEO_ENCODE_USAGE_RECORDING_BIT_KHR      = 0x00000004,
                VK_VIDEO_ENCODE_USAGE_CONFERENCING_BIT_KHR   = 0x00000008,
                VK_VIDEO_ENCODE_USAGE_FLAG_BITS_MAX_ENUM_KHR = 0x7FFFFFFF
            }
            
            enum VK_VIDEO_ENCODE_USAGE_DEFAULT_KHR           = VkVideoEncodeUsageFlagBitsKHR.VK_VIDEO_ENCODE_USAGE_DEFAULT_KHR;
            enum VK_VIDEO_ENCODE_USAGE_TRANSCODING_BIT_KHR   = VkVideoEncodeUsageFlagBitsKHR.VK_VIDEO_ENCODE_USAGE_TRANSCODING_BIT_KHR;
            enum VK_VIDEO_ENCODE_USAGE_STREAMING_BIT_KHR     = VkVideoEncodeUsageFlagBitsKHR.VK_VIDEO_ENCODE_USAGE_STREAMING_BIT_KHR;
            enum VK_VIDEO_ENCODE_USAGE_RECORDING_BIT_KHR     = VkVideoEncodeUsageFlagBitsKHR.VK_VIDEO_ENCODE_USAGE_RECORDING_BIT_KHR;
            enum VK_VIDEO_ENCODE_USAGE_CONFERENCING_BIT_KHR  = VkVideoEncodeUsageFlagBitsKHR.VK_VIDEO_ENCODE_USAGE_CONFERENCING_BIT_KHR;
            enum VK_VIDEO_ENCODE_USAGE_FLAG_BITS_MAX_ENUM_KHR = VkVideoEncodeUsageFlagBitsKHR.VK_VIDEO_ENCODE_USAGE_FLAG_BITS_MAX_ENUM_KHR;
            
            alias VkVideoEncodeContentFlagsKHR = VkFlags;
            enum VkVideoEncodeContentFlagBitsKHR : VkVideoEncodeContentFlagsKHR {
                VK_VIDEO_ENCODE_CONTENT_DEFAULT_KHR          = 0,
                VK_VIDEO_ENCODE_CONTENT_CAMERA_BIT_KHR       = 0x00000001,
                VK_VIDEO_ENCODE_CONTENT_DESKTOP_BIT_KHR      = 0x00000002,
                VK_VIDEO_ENCODE_CONTENT_RENDERED_BIT_KHR     = 0x00000004,
                VK_VIDEO_ENCODE_CONTENT_FLAG_BITS_MAX_ENUM_KHR = 0x7FFFFFFF
            }
            
            enum VK_VIDEO_ENCODE_CONTENT_DEFAULT_KHR         = VkVideoEncodeContentFlagBitsKHR.VK_VIDEO_ENCODE_CONTENT_DEFAULT_KHR;
            enum VK_VIDEO_ENCODE_CONTENT_CAMERA_BIT_KHR      = VkVideoEncodeContentFlagBitsKHR.VK_VIDEO_ENCODE_CONTENT_CAMERA_BIT_KHR;
            enum VK_VIDEO_ENCODE_CONTENT_DESKTOP_BIT_KHR     = VkVideoEncodeContentFlagBitsKHR.VK_VIDEO_ENCODE_CONTENT_DESKTOP_BIT_KHR;
            enum VK_VIDEO_ENCODE_CONTENT_RENDERED_BIT_KHR    = VkVideoEncodeContentFlagBitsKHR.VK_VIDEO_ENCODE_CONTENT_RENDERED_BIT_KHR;
            enum VK_VIDEO_ENCODE_CONTENT_FLAG_BITS_MAX_ENUM_KHR = VkVideoEncodeContentFlagBitsKHR.VK_VIDEO_ENCODE_CONTENT_FLAG_BITS_MAX_ENUM_KHR;
            alias VkVideoEncodeRateControlFlagsKHR = VkFlags;
            
            struct VkVideoEncodeInfoKHR {
                VkStructureType                        sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_INFO_KHR;
                const( void )*                         pNext;
                VkVideoEncodeFlagsKHR                  flags;
                uint32_t                               qualityLevel;
                VkBuffer                               dstBuffer;
                VkDeviceSize                           dstBufferOffset;
                VkDeviceSize                           dstBufferRange;
                VkVideoPictureResourceInfoKHR          srcPictureResource;
                const( VkVideoReferenceSlotInfoKHR )*  pSetupReferenceSlot;
                uint32_t                               referenceSlotCount;
                const( VkVideoReferenceSlotInfoKHR )*  pReferenceSlots;
                uint32_t                               precedingExternallyEncodedBytes;
            }
            
            struct VkVideoEncodeCapabilitiesKHR {
                VkStructureType                       sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_CAPABILITIES_KHR;
                void*                                 pNext;
                VkVideoEncodeCapabilityFlagsKHR       flags;
                VkVideoEncodeRateControlModeFlagsKHR  rateControlModes;
                uint32_t                              maxRateControlLayers;
                uint32_t                              maxQualityLevels;
                VkExtent2D                            inputImageDataFillAlignment;
                VkVideoEncodeFeedbackFlagsKHR         supportedEncodeFeedbackFlags;
            }
            
            struct VkQueryPoolVideoEncodeFeedbackCreateInfoKHR {
                VkStructureType                sType = VK_STRUCTURE_TYPE_QUERY_POOL_VIDEO_ENCODE_FEEDBACK_CREATE_INFO_KHR;
                const( void )*                 pNext;
                VkVideoEncodeFeedbackFlagsKHR  encodeFeedbackFlags;
            }
            
            struct VkVideoEncodeUsageInfoKHR {
                VkStructureType               sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_USAGE_INFO_KHR;
                const( void )*                pNext;
                VkVideoEncodeUsageFlagsKHR    videoUsageHints;
                VkVideoEncodeContentFlagsKHR  videoContentHints;
                VkVideoEncodeTuningModeKHR    tuningMode;
            }
            
            struct VkVideoEncodeRateControlLayerInfoKHR {
                VkStructureType  sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_RATE_CONTROL_LAYER_INFO_KHR;
                const( void )*   pNext;
                uint64_t         averageBitrate;
                uint64_t         maxBitrate;
                uint32_t         frameRateNumerator;
                uint32_t         frameRateDenominator;
                uint32_t         virtualBufferSizeInMs;
                uint32_t         initialVirtualBufferSizeInMs;
            }
            
            struct VkVideoEncodeRateControlInfoKHR {
                VkStructureType                                 sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_RATE_CONTROL_INFO_KHR;
                const( void )*                                  pNext;
                VkVideoEncodeRateControlFlagsKHR                flags;
                VkVideoEncodeRateControlModeFlagBitsKHR         rateControlMode;
                uint32_t                                        layerCount;
                const( VkVideoEncodeRateControlLayerInfoKHR )*  pLayers;
            }
            
            alias PFN_vkCmdEncodeVideoKHR                                               = void      function( VkCommandBuffer commandBuffer, const( VkVideoEncodeInfoKHR )* pEncodeInfo );
        }

        // VK_EXT_video_encode_h264 : types and function pointer type aliases
        else static if( __traits( isSame, extension, EXT_video_encode_h264 )) {
            enum VK_EXT_video_encode_h264 = 1;

            enum VK_EXT_VIDEO_ENCODE_H264_SPEC_VERSION = 10;
            enum const( char )* VK_EXT_VIDEO_ENCODE_H264_EXTENSION_NAME = "VK_EXT_video_encode_h264";
            
            enum VkVideoEncodeH264RateControlStructureEXT {
                VK_VIDEO_ENCODE_H264_RATE_CONTROL_STRUCTURE_UNKNOWN_EXT      = 0,
                VK_VIDEO_ENCODE_H264_RATE_CONTROL_STRUCTURE_FLAT_EXT         = 1,
                VK_VIDEO_ENCODE_H264_RATE_CONTROL_STRUCTURE_DYADIC_EXT       = 2,
                VK_VIDEO_ENCODE_H2_64_RATE_CONTROL_STRUCTURE_MAX_ENUM_EXT    = 0x7FFFFFFF
            }
            
            enum VK_VIDEO_ENCODE_H264_RATE_CONTROL_STRUCTURE_UNKNOWN_EXT     = VkVideoEncodeH264RateControlStructureEXT.VK_VIDEO_ENCODE_H264_RATE_CONTROL_STRUCTURE_UNKNOWN_EXT;
            enum VK_VIDEO_ENCODE_H264_RATE_CONTROL_STRUCTURE_FLAT_EXT        = VkVideoEncodeH264RateControlStructureEXT.VK_VIDEO_ENCODE_H264_RATE_CONTROL_STRUCTURE_FLAT_EXT;
            enum VK_VIDEO_ENCODE_H264_RATE_CONTROL_STRUCTURE_DYADIC_EXT      = VkVideoEncodeH264RateControlStructureEXT.VK_VIDEO_ENCODE_H264_RATE_CONTROL_STRUCTURE_DYADIC_EXT;
            enum VK_VIDEO_ENCODE_H2_64_RATE_CONTROL_STRUCTURE_MAX_ENUM_EXT   = VkVideoEncodeH264RateControlStructureEXT.VK_VIDEO_ENCODE_H2_64_RATE_CONTROL_STRUCTURE_MAX_ENUM_EXT;
            
            alias VkVideoEncodeH264CapabilityFlagsEXT = VkFlags;
            enum VkVideoEncodeH264CapabilityFlagBitsEXT : VkVideoEncodeH264CapabilityFlagsEXT {
                VK_VIDEO_ENCODE_H264_CAPABILITY_DIRECT_8X8_INFERENCE_ENABLED_BIT_EXT         = 0x00000001,
                VK_VIDEO_ENCODE_H264_CAPABILITY_DIRECT_8X8_INFERENCE_DISABLED_BIT_EXT        = 0x00000002,
                VK_VIDEO_ENCODE_H264_CAPABILITY_SEPARATE_COLOUR_PLANE_BIT_EXT                = 0x00000004,
                VK_VIDEO_ENCODE_H264_CAPABILITY_QPPRIME_Y_ZERO_TRANSFORM_BYPASS_BIT_EXT      = 0x00000008,
                VK_VIDEO_ENCODE_H264_CAPABILITY_SCALING_LISTS_BIT_EXT                        = 0x00000010,
                VK_VIDEO_ENCODE_H264_CAPABILITY_HRD_COMPLIANCE_BIT_EXT                       = 0x00000020,
                VK_VIDEO_ENCODE_H264_CAPABILITY_CHROMA_QP_OFFSET_BIT_EXT                     = 0x00000040,
                VK_VIDEO_ENCODE_H264_CAPABILITY_SECOND_CHROMA_QP_OFFSET_BIT_EXT              = 0x00000080,
                VK_VIDEO_ENCODE_H264_CAPABILITY_PIC_INIT_QP_MINUS26_BIT_EXT                  = 0x00000100,
                VK_VIDEO_ENCODE_H264_CAPABILITY_WEIGHTED_PRED_BIT_EXT                        = 0x00000200,
                VK_VIDEO_ENCODE_H264_CAPABILITY_WEIGHTED_BIPRED_EXPLICIT_BIT_EXT             = 0x00000400,
                VK_VIDEO_ENCODE_H264_CAPABILITY_WEIGHTED_BIPRED_IMPLICIT_BIT_EXT             = 0x00000800,
                VK_VIDEO_ENCODE_H264_CAPABILITY_WEIGHTED_PRED_NO_TABLE_BIT_EXT               = 0x00001000,
                VK_VIDEO_ENCODE_H264_CAPABILITY_TRANSFORM_8X8_BIT_EXT                        = 0x00002000,
                VK_VIDEO_ENCODE_H264_CAPABILITY_CABAC_BIT_EXT                                = 0x00004000,
                VK_VIDEO_ENCODE_H264_CAPABILITY_CAVLC_BIT_EXT                                = 0x00008000,
                VK_VIDEO_ENCODE_H264_CAPABILITY_DEBLOCKING_FILTER_DISABLED_BIT_EXT           = 0x00010000,
                VK_VIDEO_ENCODE_H264_CAPABILITY_DEBLOCKING_FILTER_ENABLED_BIT_EXT            = 0x00020000,
                VK_VIDEO_ENCODE_H264_CAPABILITY_DEBLOCKING_FILTER_PARTIAL_BIT_EXT            = 0x00040000,
                VK_VIDEO_ENCODE_H264_CAPABILITY_DISABLE_DIRECT_SPATIAL_MV_PRED_BIT_EXT       = 0x00080000,
                VK_VIDEO_ENCODE_H264_CAPABILITY_MULTIPLE_SLICE_PER_FRAME_BIT_EXT             = 0x00100000,
                VK_VIDEO_ENCODE_H264_CAPABILITY_SLICE_MB_COUNT_BIT_EXT                       = 0x00200000,
                VK_VIDEO_ENCODE_H264_CAPABILITY_ROW_UNALIGNED_SLICE_BIT_EXT                  = 0x00400000,
                VK_VIDEO_ENCODE_H264_CAPABILITY_DIFFERENT_SLICE_TYPE_BIT_EXT                 = 0x00800000,
                VK_VIDEO_ENCODE_H264_CAPABILITY_B_FRAME_IN_L1_LIST_BIT_EXT                   = 0x01000000,
                VK_VIDEO_ENCODE_H264_CAPABILITY_DIFFERENT_REFERENCE_FINAL_LISTS_BIT_EXT      = 0x02000000,
                VK_VIDEO_ENCODE_H2_64_CAPABILITY_FLAG_BITS_MAX_ENUM_EXT                      = 0x7FFFFFFF
            }
            
            enum VK_VIDEO_ENCODE_H264_CAPABILITY_DIRECT_8X8_INFERENCE_ENABLED_BIT_EXT        = VkVideoEncodeH264CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H264_CAPABILITY_DIRECT_8X8_INFERENCE_ENABLED_BIT_EXT;
            enum VK_VIDEO_ENCODE_H264_CAPABILITY_DIRECT_8X8_INFERENCE_DISABLED_BIT_EXT       = VkVideoEncodeH264CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H264_CAPABILITY_DIRECT_8X8_INFERENCE_DISABLED_BIT_EXT;
            enum VK_VIDEO_ENCODE_H264_CAPABILITY_SEPARATE_COLOUR_PLANE_BIT_EXT               = VkVideoEncodeH264CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H264_CAPABILITY_SEPARATE_COLOUR_PLANE_BIT_EXT;
            enum VK_VIDEO_ENCODE_H264_CAPABILITY_QPPRIME_Y_ZERO_TRANSFORM_BYPASS_BIT_EXT     = VkVideoEncodeH264CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H264_CAPABILITY_QPPRIME_Y_ZERO_TRANSFORM_BYPASS_BIT_EXT;
            enum VK_VIDEO_ENCODE_H264_CAPABILITY_SCALING_LISTS_BIT_EXT                       = VkVideoEncodeH264CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H264_CAPABILITY_SCALING_LISTS_BIT_EXT;
            enum VK_VIDEO_ENCODE_H264_CAPABILITY_HRD_COMPLIANCE_BIT_EXT                      = VkVideoEncodeH264CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H264_CAPABILITY_HRD_COMPLIANCE_BIT_EXT;
            enum VK_VIDEO_ENCODE_H264_CAPABILITY_CHROMA_QP_OFFSET_BIT_EXT                    = VkVideoEncodeH264CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H264_CAPABILITY_CHROMA_QP_OFFSET_BIT_EXT;
            enum VK_VIDEO_ENCODE_H264_CAPABILITY_SECOND_CHROMA_QP_OFFSET_BIT_EXT             = VkVideoEncodeH264CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H264_CAPABILITY_SECOND_CHROMA_QP_OFFSET_BIT_EXT;
            enum VK_VIDEO_ENCODE_H264_CAPABILITY_PIC_INIT_QP_MINUS26_BIT_EXT                 = VkVideoEncodeH264CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H264_CAPABILITY_PIC_INIT_QP_MINUS26_BIT_EXT;
            enum VK_VIDEO_ENCODE_H264_CAPABILITY_WEIGHTED_PRED_BIT_EXT                       = VkVideoEncodeH264CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H264_CAPABILITY_WEIGHTED_PRED_BIT_EXT;
            enum VK_VIDEO_ENCODE_H264_CAPABILITY_WEIGHTED_BIPRED_EXPLICIT_BIT_EXT            = VkVideoEncodeH264CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H264_CAPABILITY_WEIGHTED_BIPRED_EXPLICIT_BIT_EXT;
            enum VK_VIDEO_ENCODE_H264_CAPABILITY_WEIGHTED_BIPRED_IMPLICIT_BIT_EXT            = VkVideoEncodeH264CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H264_CAPABILITY_WEIGHTED_BIPRED_IMPLICIT_BIT_EXT;
            enum VK_VIDEO_ENCODE_H264_CAPABILITY_WEIGHTED_PRED_NO_TABLE_BIT_EXT              = VkVideoEncodeH264CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H264_CAPABILITY_WEIGHTED_PRED_NO_TABLE_BIT_EXT;
            enum VK_VIDEO_ENCODE_H264_CAPABILITY_TRANSFORM_8X8_BIT_EXT                       = VkVideoEncodeH264CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H264_CAPABILITY_TRANSFORM_8X8_BIT_EXT;
            enum VK_VIDEO_ENCODE_H264_CAPABILITY_CABAC_BIT_EXT                               = VkVideoEncodeH264CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H264_CAPABILITY_CABAC_BIT_EXT;
            enum VK_VIDEO_ENCODE_H264_CAPABILITY_CAVLC_BIT_EXT                               = VkVideoEncodeH264CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H264_CAPABILITY_CAVLC_BIT_EXT;
            enum VK_VIDEO_ENCODE_H264_CAPABILITY_DEBLOCKING_FILTER_DISABLED_BIT_EXT          = VkVideoEncodeH264CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H264_CAPABILITY_DEBLOCKING_FILTER_DISABLED_BIT_EXT;
            enum VK_VIDEO_ENCODE_H264_CAPABILITY_DEBLOCKING_FILTER_ENABLED_BIT_EXT           = VkVideoEncodeH264CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H264_CAPABILITY_DEBLOCKING_FILTER_ENABLED_BIT_EXT;
            enum VK_VIDEO_ENCODE_H264_CAPABILITY_DEBLOCKING_FILTER_PARTIAL_BIT_EXT           = VkVideoEncodeH264CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H264_CAPABILITY_DEBLOCKING_FILTER_PARTIAL_BIT_EXT;
            enum VK_VIDEO_ENCODE_H264_CAPABILITY_DISABLE_DIRECT_SPATIAL_MV_PRED_BIT_EXT      = VkVideoEncodeH264CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H264_CAPABILITY_DISABLE_DIRECT_SPATIAL_MV_PRED_BIT_EXT;
            enum VK_VIDEO_ENCODE_H264_CAPABILITY_MULTIPLE_SLICE_PER_FRAME_BIT_EXT            = VkVideoEncodeH264CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H264_CAPABILITY_MULTIPLE_SLICE_PER_FRAME_BIT_EXT;
            enum VK_VIDEO_ENCODE_H264_CAPABILITY_SLICE_MB_COUNT_BIT_EXT                      = VkVideoEncodeH264CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H264_CAPABILITY_SLICE_MB_COUNT_BIT_EXT;
            enum VK_VIDEO_ENCODE_H264_CAPABILITY_ROW_UNALIGNED_SLICE_BIT_EXT                 = VkVideoEncodeH264CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H264_CAPABILITY_ROW_UNALIGNED_SLICE_BIT_EXT;
            enum VK_VIDEO_ENCODE_H264_CAPABILITY_DIFFERENT_SLICE_TYPE_BIT_EXT                = VkVideoEncodeH264CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H264_CAPABILITY_DIFFERENT_SLICE_TYPE_BIT_EXT;
            enum VK_VIDEO_ENCODE_H264_CAPABILITY_B_FRAME_IN_L1_LIST_BIT_EXT                  = VkVideoEncodeH264CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H264_CAPABILITY_B_FRAME_IN_L1_LIST_BIT_EXT;
            enum VK_VIDEO_ENCODE_H264_CAPABILITY_DIFFERENT_REFERENCE_FINAL_LISTS_BIT_EXT     = VkVideoEncodeH264CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H264_CAPABILITY_DIFFERENT_REFERENCE_FINAL_LISTS_BIT_EXT;
            enum VK_VIDEO_ENCODE_H2_64_CAPABILITY_FLAG_BITS_MAX_ENUM_EXT                     = VkVideoEncodeH264CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H2_64_CAPABILITY_FLAG_BITS_MAX_ENUM_EXT;
            
            struct VkVideoEncodeH264CapabilitiesEXT {
                VkStructureType                      sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_H264_CAPABILITIES_EXT;
                void*                                pNext;
                VkVideoEncodeH264CapabilityFlagsEXT  flags;
                uint32_t                             maxPPictureL0ReferenceCount;
                uint32_t                             maxBPictureL0ReferenceCount;
                uint32_t                             maxL1ReferenceCount;
                VkBool32                             motionVectorsOverPicBoundariesFlag;
                uint32_t                             maxBytesPerPicDenom;
                uint32_t                             maxBitsPerMbDenom;
                uint32_t                             log2MaxMvLengthHorizontal;
                uint32_t                             log2MaxMvLengthVertical;
            }
            
            struct VkVideoEncodeH264SessionParametersAddInfoEXT {
                VkStructureType                             sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_H264_SESSION_PARAMETERS_ADD_INFO_EXT;
                const( void )*                              pNext;
                uint32_t                                    stdSPSCount;
                const( StdVideoH264SequenceParameterSet )*  pStdSPSs;
                uint32_t                                    stdPPSCount;
                const( StdVideoH264PictureParameterSet )*   pStdPPSs;
            }
            
            struct VkVideoEncodeH264SessionParametersCreateInfoEXT {
                VkStructureType                                         sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_H264_SESSION_PARAMETERS_CREATE_INFO_EXT;
                const( void )*                                          pNext;
                uint32_t                                                maxStdSPSCount;
                uint32_t                                                maxStdPPSCount;
                const( VkVideoEncodeH264SessionParametersAddInfoEXT )*  pParametersAddInfo;
            }
            
            struct VkVideoEncodeH264NaluSliceInfoEXT {
                VkStructureType                                 sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_H264_NALU_SLICE_INFO_EXT;
                const( void )*                                  pNext;
                uint32_t                                        mbCount;
                const( StdVideoEncodeH264ReferenceListsInfo )*  pStdReferenceFinalLists;
                const( StdVideoEncodeH264SliceHeader )*         pStdSliceHeader;
            }
            
            struct VkVideoEncodeH264VclFrameInfoEXT {
                VkStructureType                                 sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_H264_VCL_FRAME_INFO_EXT;
                const( void )*                                  pNext;
                const( StdVideoEncodeH264ReferenceListsInfo )*  pStdReferenceFinalLists;
                uint32_t                                        naluSliceEntryCount;
                const( VkVideoEncodeH264NaluSliceInfoEXT )*     pNaluSliceEntries;
                const( StdVideoEncodeH264PictureInfo )*         pStdPictureInfo;
            }
            
            struct VkVideoEncodeH264DpbSlotInfoEXT {
                VkStructureType                            sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_H264_DPB_SLOT_INFO_EXT;
                const( void )*                             pNext;
                const( StdVideoEncodeH264ReferenceInfo )*  pStdReferenceInfo;
            }
            
            struct VkVideoEncodeH264ProfileInfoEXT {
                VkStructureType         sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_H264_PROFILE_INFO_EXT;
                const( void )*          pNext;
                StdVideoH264ProfileIdc  stdProfileIdc;
            }
            
            struct VkVideoEncodeH264RateControlInfoEXT {
                VkStructureType                           sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_H264_RATE_CONTROL_INFO_EXT;
                const( void )*                            pNext;
                uint32_t                                  gopFrameCount;
                uint32_t                                  idrPeriod;
                uint32_t                                  consecutiveBFrameCount;
                VkVideoEncodeH264RateControlStructureEXT  rateControlStructure;
                uint32_t                                  temporalLayerCount;
            }
            
            struct VkVideoEncodeH264QpEXT {
                int32_t  qpI;
                int32_t  qpP;
                int32_t  qpB;
            }
            
            struct VkVideoEncodeH264FrameSizeEXT {
                uint32_t  frameISize;
                uint32_t  framePSize;
                uint32_t  frameBSize;
            }
            
            struct VkVideoEncodeH264RateControlLayerInfoEXT {
                VkStructureType                sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_H264_RATE_CONTROL_LAYER_INFO_EXT;
                const( void )*                 pNext;
                uint32_t                       temporalLayerId;
                VkBool32                       useInitialRcQp;
                VkVideoEncodeH264QpEXT         initialRcQp;
                VkBool32                       useMinQp;
                VkVideoEncodeH264QpEXT         minQp;
                VkBool32                       useMaxQp;
                VkVideoEncodeH264QpEXT         maxQp;
                VkBool32                       useMaxFrameSize;
                VkVideoEncodeH264FrameSizeEXT  maxFrameSize;
            }
            
        }

        // VK_EXT_video_encode_h265 : types and function pointer type aliases
        else static if( __traits( isSame, extension, EXT_video_encode_h265 )) {
            enum VK_EXT_video_encode_h265 = 1;

            enum VK_EXT_VIDEO_ENCODE_H265_SPEC_VERSION = 10;
            enum const( char )* VK_EXT_VIDEO_ENCODE_H265_EXTENSION_NAME = "VK_EXT_video_encode_h265";
            
            enum VkVideoEncodeH265RateControlStructureEXT {
                VK_VIDEO_ENCODE_H265_RATE_CONTROL_STRUCTURE_UNKNOWN_EXT      = 0,
                VK_VIDEO_ENCODE_H265_RATE_CONTROL_STRUCTURE_FLAT_EXT         = 1,
                VK_VIDEO_ENCODE_H265_RATE_CONTROL_STRUCTURE_DYADIC_EXT       = 2,
                VK_VIDEO_ENCODE_H2_65_RATE_CONTROL_STRUCTURE_MAX_ENUM_EXT    = 0x7FFFFFFF
            }
            
            enum VK_VIDEO_ENCODE_H265_RATE_CONTROL_STRUCTURE_UNKNOWN_EXT     = VkVideoEncodeH265RateControlStructureEXT.VK_VIDEO_ENCODE_H265_RATE_CONTROL_STRUCTURE_UNKNOWN_EXT;
            enum VK_VIDEO_ENCODE_H265_RATE_CONTROL_STRUCTURE_FLAT_EXT        = VkVideoEncodeH265RateControlStructureEXT.VK_VIDEO_ENCODE_H265_RATE_CONTROL_STRUCTURE_FLAT_EXT;
            enum VK_VIDEO_ENCODE_H265_RATE_CONTROL_STRUCTURE_DYADIC_EXT      = VkVideoEncodeH265RateControlStructureEXT.VK_VIDEO_ENCODE_H265_RATE_CONTROL_STRUCTURE_DYADIC_EXT;
            enum VK_VIDEO_ENCODE_H2_65_RATE_CONTROL_STRUCTURE_MAX_ENUM_EXT   = VkVideoEncodeH265RateControlStructureEXT.VK_VIDEO_ENCODE_H2_65_RATE_CONTROL_STRUCTURE_MAX_ENUM_EXT;
            
            alias VkVideoEncodeH265CapabilityFlagsEXT = VkFlags;
            enum VkVideoEncodeH265CapabilityFlagBitsEXT : VkVideoEncodeH265CapabilityFlagsEXT {
                VK_VIDEO_ENCODE_H265_CAPABILITY_SEPARATE_COLOUR_PLANE_BIT_EXT                = 0x00000001,
                VK_VIDEO_ENCODE_H265_CAPABILITY_SCALING_LISTS_BIT_EXT                        = 0x00000002,
                VK_VIDEO_ENCODE_H265_CAPABILITY_SAMPLE_ADAPTIVE_OFFSET_ENABLED_BIT_EXT       = 0x00000004,
                VK_VIDEO_ENCODE_H265_CAPABILITY_PCM_ENABLE_BIT_EXT                           = 0x00000008,
                VK_VIDEO_ENCODE_H265_CAPABILITY_SPS_TEMPORAL_MVP_ENABLED_BIT_EXT             = 0x00000010,
                VK_VIDEO_ENCODE_H265_CAPABILITY_HRD_COMPLIANCE_BIT_EXT                       = 0x00000020,
                VK_VIDEO_ENCODE_H265_CAPABILITY_INIT_QP_MINUS26_BIT_EXT                      = 0x00000040,
                VK_VIDEO_ENCODE_H265_CAPABILITY_LOG2_PARALLEL_MERGE_LEVEL_MINUS2_BIT_EXT     = 0x00000080,
                VK_VIDEO_ENCODE_H265_CAPABILITY_SIGN_DATA_HIDING_ENABLED_BIT_EXT             = 0x00000100,
                VK_VIDEO_ENCODE_H265_CAPABILITY_TRANSFORM_SKIP_ENABLED_BIT_EXT               = 0x00000200,
                VK_VIDEO_ENCODE_H265_CAPABILITY_TRANSFORM_SKIP_DISABLED_BIT_EXT              = 0x00000400,
                VK_VIDEO_ENCODE_H265_CAPABILITY_PPS_SLICE_CHROMA_QP_OFFSETS_PRESENT_BIT_EXT  = 0x00000800,
                VK_VIDEO_ENCODE_H265_CAPABILITY_WEIGHTED_PRED_BIT_EXT                        = 0x00001000,
                VK_VIDEO_ENCODE_H265_CAPABILITY_WEIGHTED_BIPRED_BIT_EXT                      = 0x00002000,
                VK_VIDEO_ENCODE_H265_CAPABILITY_WEIGHTED_PRED_NO_TABLE_BIT_EXT               = 0x00004000,
                VK_VIDEO_ENCODE_H265_CAPABILITY_TRANSQUANT_BYPASS_ENABLED_BIT_EXT            = 0x00008000,
                VK_VIDEO_ENCODE_H265_CAPABILITY_ENTROPY_CODING_SYNC_ENABLED_BIT_EXT          = 0x00010000,
                VK_VIDEO_ENCODE_H265_CAPABILITY_DEBLOCKING_FILTER_OVERRIDE_ENABLED_BIT_EXT   = 0x00020000,
                VK_VIDEO_ENCODE_H265_CAPABILITY_MULTIPLE_TILE_PER_FRAME_BIT_EXT              = 0x00040000,
                VK_VIDEO_ENCODE_H265_CAPABILITY_MULTIPLE_SLICE_PER_TILE_BIT_EXT              = 0x00080000,
                VK_VIDEO_ENCODE_H265_CAPABILITY_MULTIPLE_TILE_PER_SLICE_BIT_EXT              = 0x00100000,
                VK_VIDEO_ENCODE_H265_CAPABILITY_SLICE_SEGMENT_CTB_COUNT_BIT_EXT              = 0x00200000,
                VK_VIDEO_ENCODE_H265_CAPABILITY_ROW_UNALIGNED_SLICE_SEGMENT_BIT_EXT          = 0x00400000,
                VK_VIDEO_ENCODE_H265_CAPABILITY_DEPENDENT_SLICE_SEGMENT_BIT_EXT              = 0x00800000,
                VK_VIDEO_ENCODE_H265_CAPABILITY_DIFFERENT_SLICE_TYPE_BIT_EXT                 = 0x01000000,
                VK_VIDEO_ENCODE_H265_CAPABILITY_B_FRAME_IN_L1_LIST_BIT_EXT                   = 0x02000000,
                VK_VIDEO_ENCODE_H265_CAPABILITY_DIFFERENT_REFERENCE_FINAL_LISTS_BIT_EXT      = 0x04000000,
                VK_VIDEO_ENCODE_H2_65_CAPABILITY_FLAG_BITS_MAX_ENUM_EXT                      = 0x7FFFFFFF
            }
            
            enum VK_VIDEO_ENCODE_H265_CAPABILITY_SEPARATE_COLOUR_PLANE_BIT_EXT               = VkVideoEncodeH265CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H265_CAPABILITY_SEPARATE_COLOUR_PLANE_BIT_EXT;
            enum VK_VIDEO_ENCODE_H265_CAPABILITY_SCALING_LISTS_BIT_EXT                       = VkVideoEncodeH265CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H265_CAPABILITY_SCALING_LISTS_BIT_EXT;
            enum VK_VIDEO_ENCODE_H265_CAPABILITY_SAMPLE_ADAPTIVE_OFFSET_ENABLED_BIT_EXT      = VkVideoEncodeH265CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H265_CAPABILITY_SAMPLE_ADAPTIVE_OFFSET_ENABLED_BIT_EXT;
            enum VK_VIDEO_ENCODE_H265_CAPABILITY_PCM_ENABLE_BIT_EXT                          = VkVideoEncodeH265CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H265_CAPABILITY_PCM_ENABLE_BIT_EXT;
            enum VK_VIDEO_ENCODE_H265_CAPABILITY_SPS_TEMPORAL_MVP_ENABLED_BIT_EXT            = VkVideoEncodeH265CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H265_CAPABILITY_SPS_TEMPORAL_MVP_ENABLED_BIT_EXT;
            enum VK_VIDEO_ENCODE_H265_CAPABILITY_HRD_COMPLIANCE_BIT_EXT                      = VkVideoEncodeH265CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H265_CAPABILITY_HRD_COMPLIANCE_BIT_EXT;
            enum VK_VIDEO_ENCODE_H265_CAPABILITY_INIT_QP_MINUS26_BIT_EXT                     = VkVideoEncodeH265CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H265_CAPABILITY_INIT_QP_MINUS26_BIT_EXT;
            enum VK_VIDEO_ENCODE_H265_CAPABILITY_LOG2_PARALLEL_MERGE_LEVEL_MINUS2_BIT_EXT    = VkVideoEncodeH265CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H265_CAPABILITY_LOG2_PARALLEL_MERGE_LEVEL_MINUS2_BIT_EXT;
            enum VK_VIDEO_ENCODE_H265_CAPABILITY_SIGN_DATA_HIDING_ENABLED_BIT_EXT            = VkVideoEncodeH265CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H265_CAPABILITY_SIGN_DATA_HIDING_ENABLED_BIT_EXT;
            enum VK_VIDEO_ENCODE_H265_CAPABILITY_TRANSFORM_SKIP_ENABLED_BIT_EXT              = VkVideoEncodeH265CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H265_CAPABILITY_TRANSFORM_SKIP_ENABLED_BIT_EXT;
            enum VK_VIDEO_ENCODE_H265_CAPABILITY_TRANSFORM_SKIP_DISABLED_BIT_EXT             = VkVideoEncodeH265CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H265_CAPABILITY_TRANSFORM_SKIP_DISABLED_BIT_EXT;
            enum VK_VIDEO_ENCODE_H265_CAPABILITY_PPS_SLICE_CHROMA_QP_OFFSETS_PRESENT_BIT_EXT = VkVideoEncodeH265CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H265_CAPABILITY_PPS_SLICE_CHROMA_QP_OFFSETS_PRESENT_BIT_EXT;
            enum VK_VIDEO_ENCODE_H265_CAPABILITY_WEIGHTED_PRED_BIT_EXT                       = VkVideoEncodeH265CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H265_CAPABILITY_WEIGHTED_PRED_BIT_EXT;
            enum VK_VIDEO_ENCODE_H265_CAPABILITY_WEIGHTED_BIPRED_BIT_EXT                     = VkVideoEncodeH265CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H265_CAPABILITY_WEIGHTED_BIPRED_BIT_EXT;
            enum VK_VIDEO_ENCODE_H265_CAPABILITY_WEIGHTED_PRED_NO_TABLE_BIT_EXT              = VkVideoEncodeH265CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H265_CAPABILITY_WEIGHTED_PRED_NO_TABLE_BIT_EXT;
            enum VK_VIDEO_ENCODE_H265_CAPABILITY_TRANSQUANT_BYPASS_ENABLED_BIT_EXT           = VkVideoEncodeH265CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H265_CAPABILITY_TRANSQUANT_BYPASS_ENABLED_BIT_EXT;
            enum VK_VIDEO_ENCODE_H265_CAPABILITY_ENTROPY_CODING_SYNC_ENABLED_BIT_EXT         = VkVideoEncodeH265CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H265_CAPABILITY_ENTROPY_CODING_SYNC_ENABLED_BIT_EXT;
            enum VK_VIDEO_ENCODE_H265_CAPABILITY_DEBLOCKING_FILTER_OVERRIDE_ENABLED_BIT_EXT  = VkVideoEncodeH265CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H265_CAPABILITY_DEBLOCKING_FILTER_OVERRIDE_ENABLED_BIT_EXT;
            enum VK_VIDEO_ENCODE_H265_CAPABILITY_MULTIPLE_TILE_PER_FRAME_BIT_EXT             = VkVideoEncodeH265CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H265_CAPABILITY_MULTIPLE_TILE_PER_FRAME_BIT_EXT;
            enum VK_VIDEO_ENCODE_H265_CAPABILITY_MULTIPLE_SLICE_PER_TILE_BIT_EXT             = VkVideoEncodeH265CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H265_CAPABILITY_MULTIPLE_SLICE_PER_TILE_BIT_EXT;
            enum VK_VIDEO_ENCODE_H265_CAPABILITY_MULTIPLE_TILE_PER_SLICE_BIT_EXT             = VkVideoEncodeH265CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H265_CAPABILITY_MULTIPLE_TILE_PER_SLICE_BIT_EXT;
            enum VK_VIDEO_ENCODE_H265_CAPABILITY_SLICE_SEGMENT_CTB_COUNT_BIT_EXT             = VkVideoEncodeH265CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H265_CAPABILITY_SLICE_SEGMENT_CTB_COUNT_BIT_EXT;
            enum VK_VIDEO_ENCODE_H265_CAPABILITY_ROW_UNALIGNED_SLICE_SEGMENT_BIT_EXT         = VkVideoEncodeH265CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H265_CAPABILITY_ROW_UNALIGNED_SLICE_SEGMENT_BIT_EXT;
            enum VK_VIDEO_ENCODE_H265_CAPABILITY_DEPENDENT_SLICE_SEGMENT_BIT_EXT             = VkVideoEncodeH265CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H265_CAPABILITY_DEPENDENT_SLICE_SEGMENT_BIT_EXT;
            enum VK_VIDEO_ENCODE_H265_CAPABILITY_DIFFERENT_SLICE_TYPE_BIT_EXT                = VkVideoEncodeH265CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H265_CAPABILITY_DIFFERENT_SLICE_TYPE_BIT_EXT;
            enum VK_VIDEO_ENCODE_H265_CAPABILITY_B_FRAME_IN_L1_LIST_BIT_EXT                  = VkVideoEncodeH265CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H265_CAPABILITY_B_FRAME_IN_L1_LIST_BIT_EXT;
            enum VK_VIDEO_ENCODE_H265_CAPABILITY_DIFFERENT_REFERENCE_FINAL_LISTS_BIT_EXT     = VkVideoEncodeH265CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H265_CAPABILITY_DIFFERENT_REFERENCE_FINAL_LISTS_BIT_EXT;
            enum VK_VIDEO_ENCODE_H2_65_CAPABILITY_FLAG_BITS_MAX_ENUM_EXT                     = VkVideoEncodeH265CapabilityFlagBitsEXT.VK_VIDEO_ENCODE_H2_65_CAPABILITY_FLAG_BITS_MAX_ENUM_EXT;
            
            alias VkVideoEncodeH265CtbSizeFlagsEXT = VkFlags;
            enum VkVideoEncodeH265CtbSizeFlagBitsEXT : VkVideoEncodeH265CtbSizeFlagsEXT {
                VK_VIDEO_ENCODE_H265_CTB_SIZE_16_BIT_EXT     = 0x00000001,
                VK_VIDEO_ENCODE_H265_CTB_SIZE_32_BIT_EXT     = 0x00000002,
                VK_VIDEO_ENCODE_H265_CTB_SIZE_64_BIT_EXT     = 0x00000004,
                VK_VIDEO_ENCODE_H2_65_CTB_SIZE_FLAG_BITS_MAX_ENUM_EXT = 0x7FFFFFFF
            }
            
            enum VK_VIDEO_ENCODE_H265_CTB_SIZE_16_BIT_EXT    = VkVideoEncodeH265CtbSizeFlagBitsEXT.VK_VIDEO_ENCODE_H265_CTB_SIZE_16_BIT_EXT;
            enum VK_VIDEO_ENCODE_H265_CTB_SIZE_32_BIT_EXT    = VkVideoEncodeH265CtbSizeFlagBitsEXT.VK_VIDEO_ENCODE_H265_CTB_SIZE_32_BIT_EXT;
            enum VK_VIDEO_ENCODE_H265_CTB_SIZE_64_BIT_EXT    = VkVideoEncodeH265CtbSizeFlagBitsEXT.VK_VIDEO_ENCODE_H265_CTB_SIZE_64_BIT_EXT;
            enum VK_VIDEO_ENCODE_H2_65_CTB_SIZE_FLAG_BITS_MAX_ENUM_EXT = VkVideoEncodeH265CtbSizeFlagBitsEXT.VK_VIDEO_ENCODE_H2_65_CTB_SIZE_FLAG_BITS_MAX_ENUM_EXT;
            
            alias VkVideoEncodeH265TransformBlockSizeFlagsEXT = VkFlags;
            enum VkVideoEncodeH265TransformBlockSizeFlagBitsEXT : VkVideoEncodeH265TransformBlockSizeFlagsEXT {
                VK_VIDEO_ENCODE_H265_TRANSFORM_BLOCK_SIZE_4_BIT_EXT          = 0x00000001,
                VK_VIDEO_ENCODE_H265_TRANSFORM_BLOCK_SIZE_8_BIT_EXT          = 0x00000002,
                VK_VIDEO_ENCODE_H265_TRANSFORM_BLOCK_SIZE_16_BIT_EXT         = 0x00000004,
                VK_VIDEO_ENCODE_H265_TRANSFORM_BLOCK_SIZE_32_BIT_EXT         = 0x00000008,
                VK_VIDEO_ENCODE_H2_65_TRANSFORM_BLOCK_SIZE_FLAG_BITS_MAX_ENUM_EXT = 0x7FFFFFFF
            }
            
            enum VK_VIDEO_ENCODE_H265_TRANSFORM_BLOCK_SIZE_4_BIT_EXT         = VkVideoEncodeH265TransformBlockSizeFlagBitsEXT.VK_VIDEO_ENCODE_H265_TRANSFORM_BLOCK_SIZE_4_BIT_EXT;
            enum VK_VIDEO_ENCODE_H265_TRANSFORM_BLOCK_SIZE_8_BIT_EXT         = VkVideoEncodeH265TransformBlockSizeFlagBitsEXT.VK_VIDEO_ENCODE_H265_TRANSFORM_BLOCK_SIZE_8_BIT_EXT;
            enum VK_VIDEO_ENCODE_H265_TRANSFORM_BLOCK_SIZE_16_BIT_EXT        = VkVideoEncodeH265TransformBlockSizeFlagBitsEXT.VK_VIDEO_ENCODE_H265_TRANSFORM_BLOCK_SIZE_16_BIT_EXT;
            enum VK_VIDEO_ENCODE_H265_TRANSFORM_BLOCK_SIZE_32_BIT_EXT        = VkVideoEncodeH265TransformBlockSizeFlagBitsEXT.VK_VIDEO_ENCODE_H265_TRANSFORM_BLOCK_SIZE_32_BIT_EXT;
            enum VK_VIDEO_ENCODE_H2_65_TRANSFORM_BLOCK_SIZE_FLAG_BITS_MAX_ENUM_EXT = VkVideoEncodeH265TransformBlockSizeFlagBitsEXT.VK_VIDEO_ENCODE_H2_65_TRANSFORM_BLOCK_SIZE_FLAG_BITS_MAX_ENUM_EXT;
            
            struct VkVideoEncodeH265CapabilitiesEXT {
                VkStructureType                              sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_H265_CAPABILITIES_EXT;
                void*                                        pNext;
                VkVideoEncodeH265CapabilityFlagsEXT          flags;
                VkVideoEncodeH265CtbSizeFlagsEXT             ctbSizes;
                VkVideoEncodeH265TransformBlockSizeFlagsEXT  transformBlockSizes;
                uint32_t                                     maxPPictureL0ReferenceCount;
                uint32_t                                     maxBPictureL0ReferenceCount;
                uint32_t                                     maxL1ReferenceCount;
                uint32_t                                     maxSubLayersCount;
                uint32_t                                     minLog2MinLumaCodingBlockSizeMinus3;
                uint32_t                                     maxLog2MinLumaCodingBlockSizeMinus3;
                uint32_t                                     minLog2MinLumaTransformBlockSizeMinus2;
                uint32_t                                     maxLog2MinLumaTransformBlockSizeMinus2;
                uint32_t                                     minMaxTransformHierarchyDepthInter;
                uint32_t                                     maxMaxTransformHierarchyDepthInter;
                uint32_t                                     minMaxTransformHierarchyDepthIntra;
                uint32_t                                     maxMaxTransformHierarchyDepthIntra;
                uint32_t                                     maxDiffCuQpDeltaDepth;
                uint32_t                                     minMaxNumMergeCand;
                uint32_t                                     maxMaxNumMergeCand;
            }
            
            struct VkVideoEncodeH265SessionParametersAddInfoEXT {
                VkStructureType                             sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_H265_SESSION_PARAMETERS_ADD_INFO_EXT;
                const( void )*                              pNext;
                uint32_t                                    stdVPSCount;
                const( StdVideoH265VideoParameterSet )*     pStdVPSs;
                uint32_t                                    stdSPSCount;
                const( StdVideoH265SequenceParameterSet )*  pStdSPSs;
                uint32_t                                    stdPPSCount;
                const( StdVideoH265PictureParameterSet )*   pStdPPSs;
            }
            
            struct VkVideoEncodeH265SessionParametersCreateInfoEXT {
                VkStructureType                                         sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_H265_SESSION_PARAMETERS_CREATE_INFO_EXT;
                const( void )*                                          pNext;
                uint32_t                                                maxStdVPSCount;
                uint32_t                                                maxStdSPSCount;
                uint32_t                                                maxStdPPSCount;
                const( VkVideoEncodeH265SessionParametersAddInfoEXT )*  pParametersAddInfo;
            }
            
            struct VkVideoEncodeH265NaluSliceSegmentInfoEXT {
                VkStructureType                                 sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_H265_NALU_SLICE_SEGMENT_INFO_EXT;
                const( void )*                                  pNext;
                uint32_t                                        ctbCount;
                const( StdVideoEncodeH265ReferenceListsInfo )*  pStdReferenceFinalLists;
                const( StdVideoEncodeH265SliceSegmentHeader )*  pStdSliceSegmentHeader;
            }
            
            struct VkVideoEncodeH265VclFrameInfoEXT {
                VkStructureType                                     sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_H265_VCL_FRAME_INFO_EXT;
                const( void )*                                      pNext;
                const( StdVideoEncodeH265ReferenceListsInfo )*      pStdReferenceFinalLists;
                uint32_t                                            naluSliceSegmentEntryCount;
                const( VkVideoEncodeH265NaluSliceSegmentInfoEXT )*  pNaluSliceSegmentEntries;
                const( StdVideoEncodeH265PictureInfo )*             pStdPictureInfo;
            }
            
            struct VkVideoEncodeH265DpbSlotInfoEXT {
                VkStructureType                            sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_H265_DPB_SLOT_INFO_EXT;
                const( void )*                             pNext;
                const( StdVideoEncodeH265ReferenceInfo )*  pStdReferenceInfo;
            }
            
            struct VkVideoEncodeH265ProfileInfoEXT {
                VkStructureType         sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_H265_PROFILE_INFO_EXT;
                const( void )*          pNext;
                StdVideoH265ProfileIdc  stdProfileIdc;
            }
            
            struct VkVideoEncodeH265RateControlInfoEXT {
                VkStructureType                           sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_H265_RATE_CONTROL_INFO_EXT;
                const( void )*                            pNext;
                uint32_t                                  gopFrameCount;
                uint32_t                                  idrPeriod;
                uint32_t                                  consecutiveBFrameCount;
                VkVideoEncodeH265RateControlStructureEXT  rateControlStructure;
                uint32_t                                  subLayerCount;
            }
            
            struct VkVideoEncodeH265QpEXT {
                int32_t  qpI;
                int32_t  qpP;
                int32_t  qpB;
            }
            
            struct VkVideoEncodeH265FrameSizeEXT {
                uint32_t  frameISize;
                uint32_t  framePSize;
                uint32_t  frameBSize;
            }
            
            struct VkVideoEncodeH265RateControlLayerInfoEXT {
                VkStructureType                sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_H265_RATE_CONTROL_LAYER_INFO_EXT;
                const( void )*                 pNext;
                uint32_t                       temporalId;
                VkBool32                       useInitialRcQp;
                VkVideoEncodeH265QpEXT         initialRcQp;
                VkBool32                       useMinQp;
                VkVideoEncodeH265QpEXT         minQp;
                VkBool32                       useMaxQp;
                VkVideoEncodeH265QpEXT         maxQp;
                VkBool32                       useMaxFrameSize;
                VkVideoEncodeH265FrameSizeEXT  maxFrameSize;
            }
            
        }

        // VK_GGP_stream_descriptor_surface : types and function pointer type aliases
        else static if( __traits( isSame, extension, GGP_stream_descriptor_surface )) {
            enum VK_GGP_stream_descriptor_surface = 1;

            enum VK_GGP_STREAM_DESCRIPTOR_SURFACE_SPEC_VERSION = 1;
            enum const( char )* VK_GGP_STREAM_DESCRIPTOR_SURFACE_EXTENSION_NAME = "VK_GGP_stream_descriptor_surface";
            
            alias VkStreamDescriptorSurfaceCreateFlagsGGP = VkFlags;
            
            struct VkStreamDescriptorSurfaceCreateInfoGGP {
                VkStructureType                          sType = VK_STRUCTURE_TYPE_STREAM_DESCRIPTOR_SURFACE_CREATE_INFO_GGP;
                const( void )*                           pNext;
                VkStreamDescriptorSurfaceCreateFlagsGGP  flags;
                GgpStreamDescriptor                      streamDescriptor;
            }
            
            alias PFN_vkCreateStreamDescriptorSurfaceGGP                                = VkResult  function( VkInstance instance, const( VkStreamDescriptorSurfaceCreateInfoGGP )* pCreateInfo, const( VkAllocationCallbacks )* pAllocator, VkSurfaceKHR* pSurface );
        }

        // VK_NV_external_memory_win32 : types and function pointer type aliases
        else static if( __traits( isSame, extension, NV_external_memory_win32 )) {
            enum VK_NV_external_memory_win32 = 1;

            enum VK_NV_EXTERNAL_MEMORY_WIN32_SPEC_VERSION = 1;
            enum const( char )* VK_NV_EXTERNAL_MEMORY_WIN32_EXTENSION_NAME = "VK_NV_external_memory_win32";
            
            struct VkImportMemoryWin32HandleInfoNV {
                VkStructureType                    sType = VK_STRUCTURE_TYPE_IMPORT_MEMORY_WIN32_HANDLE_INFO_NV;
                const( void )*                     pNext;
                VkExternalMemoryHandleTypeFlagsNV  handleType;
                HANDLE                             handle;
            }
            
            struct VkExportMemoryWin32HandleInfoNV {
                VkStructureType                sType = VK_STRUCTURE_TYPE_EXPORT_MEMORY_WIN32_HANDLE_INFO_NV;
                const( void )*                 pNext;
                const( SECURITY_ATTRIBUTES )*  pAttributes;
                DWORD                          dwAccess;
            }
            
            alias PFN_vkGetMemoryWin32HandleNV                                          = VkResult  function( VkDevice device, VkDeviceMemory memory, VkExternalMemoryHandleTypeFlagsNV handleType, HANDLE* pHandle );
        }

        // VK_NV_win32_keyed_mutex : types and function pointer type aliases
        else static if( __traits( isSame, extension, NV_win32_keyed_mutex )) {
            enum VK_NV_win32_keyed_mutex = 1;

            enum VK_NV_WIN32_KEYED_MUTEX_SPEC_VERSION = 2;
            enum const( char )* VK_NV_WIN32_KEYED_MUTEX_EXTENSION_NAME = "VK_NV_win32_keyed_mutex";
            
            struct VkWin32KeyedMutexAcquireReleaseInfoNV {
                VkStructureType           sType = VK_STRUCTURE_TYPE_WIN32_KEYED_MUTEX_ACQUIRE_RELEASE_INFO_NV;
                const( void )*            pNext;
                uint32_t                  acquireCount;
                const( VkDeviceMemory )*  pAcquireSyncs;
                const( uint64_t )*        pAcquireKeys;
                const( uint32_t )*        pAcquireTimeoutMilliseconds;
                uint32_t                  releaseCount;
                const( VkDeviceMemory )*  pReleaseSyncs;
                const( uint64_t )*        pReleaseKeys;
            }
            
        }

        // VK_NN_vi_surface : types and function pointer type aliases
        else static if( __traits( isSame, extension, NN_vi_surface )) {
            enum VK_NN_vi_surface = 1;

            enum VK_NN_VI_SURFACE_SPEC_VERSION = 1;
            enum const( char )* VK_NN_VI_SURFACE_EXTENSION_NAME = "VK_NN_vi_surface";
            
            alias VkViSurfaceCreateFlagsNN = VkFlags;
            
            struct VkViSurfaceCreateInfoNN {
                VkStructureType           sType = VK_STRUCTURE_TYPE_VI_SURFACE_CREATE_INFO_NN;
                const( void )*            pNext;
                VkViSurfaceCreateFlagsNN  flags;
                void*                     window;
            }
            
            alias PFN_vkCreateViSurfaceNN                                               = VkResult  function( VkInstance instance, const( VkViSurfaceCreateInfoNN )* pCreateInfo, const( VkAllocationCallbacks )* pAllocator, VkSurfaceKHR* pSurface );
        }

        // VK_EXT_acquire_xlib_display : types and function pointer type aliases
        else static if( __traits( isSame, extension, EXT_acquire_xlib_display )) {
            enum VK_EXT_acquire_xlib_display = 1;

            enum VK_EXT_ACQUIRE_XLIB_DISPLAY_SPEC_VERSION = 1;
            enum const( char )* VK_EXT_ACQUIRE_XLIB_DISPLAY_EXTENSION_NAME = "VK_EXT_acquire_xlib_display";
            
            alias PFN_vkAcquireXlibDisplayEXT                                           = VkResult  function( VkPhysicalDevice physicalDevice, Display* dpy, VkDisplayKHR display );
            alias PFN_vkGetRandROutputDisplayEXT                                        = VkResult  function( VkPhysicalDevice physicalDevice, Display* dpy, RROutput rrOutput, VkDisplayKHR* pDisplay );
        }

        // VK_MVK_ios_surface : types and function pointer type aliases
        else static if( __traits( isSame, extension, MVK_ios_surface )) {
            enum VK_MVK_ios_surface = 1;

            enum VK_MVK_IOS_SURFACE_SPEC_VERSION = 3;
            enum const( char )* VK_MVK_IOS_SURFACE_EXTENSION_NAME = "VK_MVK_ios_surface";
            
            alias VkIOSSurfaceCreateFlagsMVK = VkFlags;
            
            struct VkIOSSurfaceCreateInfoMVK {
                VkStructureType             sType = VK_STRUCTURE_TYPE_IOS_SURFACE_CREATE_INFO_MVK;
                const( void )*              pNext;
                VkIOSSurfaceCreateFlagsMVK  flags;
                const( void )*              pView;
            }
            
            alias PFN_vkCreateIOSSurfaceMVK                                             = VkResult  function( VkInstance instance, const( VkIOSSurfaceCreateInfoMVK )* pCreateInfo, const( VkAllocationCallbacks )* pAllocator, VkSurfaceKHR* pSurface );
        }

        // VK_MVK_macos_surface : types and function pointer type aliases
        else static if( __traits( isSame, extension, MVK_macos_surface )) {
            enum VK_MVK_macos_surface = 1;

            enum VK_MVK_MACOS_SURFACE_SPEC_VERSION = 3;
            enum const( char )* VK_MVK_MACOS_SURFACE_EXTENSION_NAME = "VK_MVK_macos_surface";
            
            alias VkMacOSSurfaceCreateFlagsMVK = VkFlags;
            
            struct VkMacOSSurfaceCreateInfoMVK {
                VkStructureType               sType = VK_STRUCTURE_TYPE_MACOS_SURFACE_CREATE_INFO_MVK;
                const( void )*                pNext;
                VkMacOSSurfaceCreateFlagsMVK  flags;
                const( void )*                pView;
            }
            
            alias PFN_vkCreateMacOSSurfaceMVK                                           = VkResult  function( VkInstance instance, const( VkMacOSSurfaceCreateInfoMVK )* pCreateInfo, const( VkAllocationCallbacks )* pAllocator, VkSurfaceKHR* pSurface );
        }

        // VK_ANDROID_external_memory_android_hardware_buffer : types and function pointer type aliases
        else static if( __traits( isSame, extension, ANDROID_external_memory_android_hardware_buffer )) {
            enum VK_ANDROID_external_memory_android_hardware_buffer = 1;

            enum VK_ANDROID_EXTERNAL_MEMORY_ANDROID_HARDWARE_BUFFER_SPEC_VERSION = 5;
            enum const( char )* VK_ANDROID_EXTERNAL_MEMORY_ANDROID_HARDWARE_BUFFER_EXTENSION_NAME = "VK_ANDROID_external_memory_android_hardware_buffer";
            
            struct VkAndroidHardwareBufferUsageANDROID {
                VkStructureType  sType = VK_STRUCTURE_TYPE_ANDROID_HARDWARE_BUFFER_USAGE_ANDROID;
                void*            pNext;
                uint64_t         androidHardwareBufferUsage;
            }
            
            struct VkAndroidHardwareBufferPropertiesANDROID {
                VkStructureType  sType = VK_STRUCTURE_TYPE_ANDROID_HARDWARE_BUFFER_PROPERTIES_ANDROID;
                void*            pNext;
                VkDeviceSize     allocationSize;
                uint32_t         memoryTypeBits;
            }
            
            struct VkAndroidHardwareBufferFormatPropertiesANDROID {
                VkStructureType                sType = VK_STRUCTURE_TYPE_ANDROID_HARDWARE_BUFFER_FORMAT_PROPERTIES_ANDROID;
                void*                          pNext;
                VkFormat                       format;
                uint64_t                       externalFormat;
                VkFormatFeatureFlags           formatFeatures;
                VkComponentMapping             samplerYcbcrConversionComponents;
                VkSamplerYcbcrModelConversion  suggestedYcbcrModel;
                VkSamplerYcbcrRange            suggestedYcbcrRange;
                VkChromaLocation               suggestedXChromaOffset;
                VkChromaLocation               suggestedYChromaOffset;
            }
            
            struct VkImportAndroidHardwareBufferInfoANDROID {
                VkStructureType            sType = VK_STRUCTURE_TYPE_IMPORT_ANDROID_HARDWARE_BUFFER_INFO_ANDROID;
                const( void )*             pNext;
                const( AHardwareBuffer )*  buffer;
            }
            
            struct VkMemoryGetAndroidHardwareBufferInfoANDROID {
                VkStructureType  sType = VK_STRUCTURE_TYPE_MEMORY_GET_ANDROID_HARDWARE_BUFFER_INFO_ANDROID;
                const( void )*   pNext;
                VkDeviceMemory   memory;
            }
            
            struct VkExternalFormatANDROID {
                VkStructureType  sType = VK_STRUCTURE_TYPE_EXTERNAL_FORMAT_ANDROID;
                void*            pNext;
                uint64_t         externalFormat;
            }
            
            struct VkAndroidHardwareBufferFormatProperties2ANDROID {
                VkStructureType                sType = VK_STRUCTURE_TYPE_ANDROID_HARDWARE_BUFFER_FORMAT_PROPERTIES_2_ANDROID;
                void*                          pNext;
                VkFormat                       format;
                uint64_t                       externalFormat;
                VkFormatFeatureFlags2          formatFeatures;
                VkComponentMapping             samplerYcbcrConversionComponents;
                VkSamplerYcbcrModelConversion  suggestedYcbcrModel;
                VkSamplerYcbcrRange            suggestedYcbcrRange;
                VkChromaLocation               suggestedXChromaOffset;
                VkChromaLocation               suggestedYChromaOffset;
            }
            
            alias PFN_vkGetAndroidHardwareBufferPropertiesANDROID                       = VkResult  function( VkDevice device, const( AHardwareBuffer )* buffer, VkAndroidHardwareBufferPropertiesANDROID* pProperties );
            alias PFN_vkGetMemoryAndroidHardwareBufferANDROID                           = VkResult  function( VkDevice device, const( VkMemoryGetAndroidHardwareBufferInfoANDROID )* pInfo, AHardwareBuffer pBuffer );
        }

        // VK_GGP_frame_token : types and function pointer type aliases
        else static if( __traits( isSame, extension, GGP_frame_token )) {
            enum VK_GGP_frame_token = 1;

            enum VK_GGP_FRAME_TOKEN_SPEC_VERSION = 1;
            enum const( char )* VK_GGP_FRAME_TOKEN_EXTENSION_NAME = "VK_GGP_frame_token";
            
            struct VkPresentFrameTokenGGP {
                VkStructureType  sType = VK_STRUCTURE_TYPE_PRESENT_FRAME_TOKEN_GGP;
                const( void )*   pNext;
                GgpFrameToken    frameToken;
            }
            
        }

        // VK_FUCHSIA_imagepipe_surface : types and function pointer type aliases
        else static if( __traits( isSame, extension, FUCHSIA_imagepipe_surface )) {
            enum VK_FUCHSIA_imagepipe_surface = 1;

            enum VK_FUCHSIA_IMAGEPIPE_SURFACE_SPEC_VERSION = 1;
            enum const( char )* VK_FUCHSIA_IMAGEPIPE_SURFACE_EXTENSION_NAME = "VK_FUCHSIA_imagepipe_surface";
            
            alias VkImagePipeSurfaceCreateFlagsFUCHSIA = VkFlags;
            
            struct VkImagePipeSurfaceCreateInfoFUCHSIA {
                VkStructureType                       sType = VK_STRUCTURE_TYPE_IMAGEPIPE_SURFACE_CREATE_INFO_FUCHSIA;
                const( void )*                        pNext;
                VkImagePipeSurfaceCreateFlagsFUCHSIA  flags;
                zx_handle_t                           imagePipeHandle;
            }
            
            alias PFN_vkCreateImagePipeSurfaceFUCHSIA                                   = VkResult  function( VkInstance instance, const( VkImagePipeSurfaceCreateInfoFUCHSIA )* pCreateInfo, const( VkAllocationCallbacks )* pAllocator, VkSurfaceKHR* pSurface );
        }

        // VK_EXT_metal_surface : types and function pointer type aliases
        else static if( __traits( isSame, extension, EXT_metal_surface )) {
            enum VK_EXT_metal_surface = 1;

            enum VK_EXT_METAL_SURFACE_SPEC_VERSION = 1;
            enum const( char )* VK_EXT_METAL_SURFACE_EXTENSION_NAME = "VK_EXT_metal_surface";
            
            alias VkMetalSurfaceCreateFlagsEXT = VkFlags;
            
            struct VkMetalSurfaceCreateInfoEXT {
                VkStructureType               sType = VK_STRUCTURE_TYPE_METAL_SURFACE_CREATE_INFO_EXT;
                const( void )*                pNext;
                VkMetalSurfaceCreateFlagsEXT  flags;
                const( CAMetalLayer )*        pLayer;
            }
            
            alias PFN_vkCreateMetalSurfaceEXT                                           = VkResult  function( VkInstance instance, const( VkMetalSurfaceCreateInfoEXT )* pCreateInfo, const( VkAllocationCallbacks )* pAllocator, VkSurfaceKHR* pSurface );
        }

        // VK_EXT_full_screen_exclusive : types and function pointer type aliases
        else static if( __traits( isSame, extension, EXT_full_screen_exclusive )) {
            enum VK_EXT_full_screen_exclusive = 1;

            enum VK_EXT_FULL_SCREEN_EXCLUSIVE_SPEC_VERSION = 4;
            enum const( char )* VK_EXT_FULL_SCREEN_EXCLUSIVE_EXTENSION_NAME = "VK_EXT_full_screen_exclusive";
            
            enum VkFullScreenExclusiveEXT {
                VK_FULL_SCREEN_EXCLUSIVE_DEFAULT_EXT                 = 0,
                VK_FULL_SCREEN_EXCLUSIVE_ALLOWED_EXT                 = 1,
                VK_FULL_SCREEN_EXCLUSIVE_DISALLOWED_EXT              = 2,
                VK_FULL_SCREEN_EXCLUSIVE_APPLICATION_CONTROLLED_EXT  = 3,
                VK_FULL_SCREEN_EXCLUSIVE_MAX_ENUM_EXT                = 0x7FFFFFFF
            }
            
            enum VK_FULL_SCREEN_EXCLUSIVE_DEFAULT_EXT                = VkFullScreenExclusiveEXT.VK_FULL_SCREEN_EXCLUSIVE_DEFAULT_EXT;
            enum VK_FULL_SCREEN_EXCLUSIVE_ALLOWED_EXT                = VkFullScreenExclusiveEXT.VK_FULL_SCREEN_EXCLUSIVE_ALLOWED_EXT;
            enum VK_FULL_SCREEN_EXCLUSIVE_DISALLOWED_EXT             = VkFullScreenExclusiveEXT.VK_FULL_SCREEN_EXCLUSIVE_DISALLOWED_EXT;
            enum VK_FULL_SCREEN_EXCLUSIVE_APPLICATION_CONTROLLED_EXT = VkFullScreenExclusiveEXT.VK_FULL_SCREEN_EXCLUSIVE_APPLICATION_CONTROLLED_EXT;
            enum VK_FULL_SCREEN_EXCLUSIVE_MAX_ENUM_EXT               = VkFullScreenExclusiveEXT.VK_FULL_SCREEN_EXCLUSIVE_MAX_ENUM_EXT;
            
            struct VkSurfaceFullScreenExclusiveInfoEXT {
                VkStructureType           sType = VK_STRUCTURE_TYPE_SURFACE_FULL_SCREEN_EXCLUSIVE_INFO_EXT;
                void*                     pNext;
                VkFullScreenExclusiveEXT  fullScreenExclusive;
            }
            
            struct VkSurfaceCapabilitiesFullScreenExclusiveEXT {
                VkStructureType  sType = VK_STRUCTURE_TYPE_SURFACE_CAPABILITIES_FULL_SCREEN_EXCLUSIVE_EXT;
                void*            pNext;
                VkBool32         fullScreenExclusiveSupported;
            }
            
            struct VkSurfaceFullScreenExclusiveWin32InfoEXT {
                VkStructureType  sType = VK_STRUCTURE_TYPE_SURFACE_FULL_SCREEN_EXCLUSIVE_WIN32_INFO_EXT;
                const( void )*   pNext;
                HMONITOR         hmonitor;
            }
            
            alias PFN_vkGetPhysicalDeviceSurfacePresentModes2EXT                        = VkResult  function( VkPhysicalDevice physicalDevice, const( VkPhysicalDeviceSurfaceInfo2KHR )* pSurfaceInfo, uint32_t* pPresentModeCount, VkPresentModeKHR* pPresentModes );
            alias PFN_vkAcquireFullScreenExclusiveModeEXT                               = VkResult  function( VkDevice device, VkSwapchainKHR swapchain );
            alias PFN_vkReleaseFullScreenExclusiveModeEXT                               = VkResult  function( VkDevice device, VkSwapchainKHR swapchain );
            alias PFN_vkGetDeviceGroupSurfacePresentModes2EXT                           = VkResult  function( VkDevice device, const( VkPhysicalDeviceSurfaceInfo2KHR )* pSurfaceInfo, VkDeviceGroupPresentModeFlagsKHR* pModes );
        }

        // VK_EXT_metal_objects : types and function pointer type aliases
        else static if( __traits( isSame, extension, EXT_metal_objects )) {
            enum VK_EXT_metal_objects = 1;

            enum VK_EXT_METAL_OBJECTS_SPEC_VERSION = 1;
            enum const( char )* VK_EXT_METAL_OBJECTS_EXTENSION_NAME = "VK_EXT_metal_objects";
            
            alias VkExportMetalObjectTypeFlagsEXT = VkFlags;
            enum VkExportMetalObjectTypeFlagBitsEXT : VkExportMetalObjectTypeFlagsEXT {
                VK_EXPORT_METAL_OBJECT_TYPE_METAL_DEVICE_BIT_EXT             = 0x00000001,
                VK_EXPORT_METAL_OBJECT_TYPE_METAL_COMMAND_QUEUE_BIT_EXT      = 0x00000002,
                VK_EXPORT_METAL_OBJECT_TYPE_METAL_BUFFER_BIT_EXT             = 0x00000004,
                VK_EXPORT_METAL_OBJECT_TYPE_METAL_TEXTURE_BIT_EXT            = 0x00000008,
                VK_EXPORT_METAL_OBJECT_TYPE_METAL_IOSURFACE_BIT_EXT          = 0x00000010,
                VK_EXPORT_METAL_OBJECT_TYPE_METAL_SHARED_EVENT_BIT_EXT       = 0x00000020,
                VK_EXPORT_METAL_OBJECT_TYPE_FLAG_BITS_MAX_ENUM_EXT           = 0x7FFFFFFF
            }
            
            enum VK_EXPORT_METAL_OBJECT_TYPE_METAL_DEVICE_BIT_EXT            = VkExportMetalObjectTypeFlagBitsEXT.VK_EXPORT_METAL_OBJECT_TYPE_METAL_DEVICE_BIT_EXT;
            enum VK_EXPORT_METAL_OBJECT_TYPE_METAL_COMMAND_QUEUE_BIT_EXT     = VkExportMetalObjectTypeFlagBitsEXT.VK_EXPORT_METAL_OBJECT_TYPE_METAL_COMMAND_QUEUE_BIT_EXT;
            enum VK_EXPORT_METAL_OBJECT_TYPE_METAL_BUFFER_BIT_EXT            = VkExportMetalObjectTypeFlagBitsEXT.VK_EXPORT_METAL_OBJECT_TYPE_METAL_BUFFER_BIT_EXT;
            enum VK_EXPORT_METAL_OBJECT_TYPE_METAL_TEXTURE_BIT_EXT           = VkExportMetalObjectTypeFlagBitsEXT.VK_EXPORT_METAL_OBJECT_TYPE_METAL_TEXTURE_BIT_EXT;
            enum VK_EXPORT_METAL_OBJECT_TYPE_METAL_IOSURFACE_BIT_EXT         = VkExportMetalObjectTypeFlagBitsEXT.VK_EXPORT_METAL_OBJECT_TYPE_METAL_IOSURFACE_BIT_EXT;
            enum VK_EXPORT_METAL_OBJECT_TYPE_METAL_SHARED_EVENT_BIT_EXT      = VkExportMetalObjectTypeFlagBitsEXT.VK_EXPORT_METAL_OBJECT_TYPE_METAL_SHARED_EVENT_BIT_EXT;
            enum VK_EXPORT_METAL_OBJECT_TYPE_FLAG_BITS_MAX_ENUM_EXT          = VkExportMetalObjectTypeFlagBitsEXT.VK_EXPORT_METAL_OBJECT_TYPE_FLAG_BITS_MAX_ENUM_EXT;
            
            struct VkExportMetalObjectCreateInfoEXT {
                VkStructureType                     sType = VK_STRUCTURE_TYPE_EXPORT_METAL_OBJECT_CREATE_INFO_EXT;
                const( void )*                      pNext;
                VkExportMetalObjectTypeFlagBitsEXT  exportObjectType;
            }
            
            struct VkExportMetalObjectsInfoEXT {
                VkStructureType  sType = VK_STRUCTURE_TYPE_EXPORT_METAL_OBJECTS_INFO_EXT;
                const( void )*   pNext;
            }
            
            struct VkExportMetalDeviceInfoEXT {
                VkStructureType  sType = VK_STRUCTURE_TYPE_EXPORT_METAL_DEVICE_INFO_EXT;
                const( void )*   pNext;
                MTLDevice_id     mtlDevice;
            }
            
            struct VkExportMetalCommandQueueInfoEXT {
                VkStructureType     sType = VK_STRUCTURE_TYPE_EXPORT_METAL_COMMAND_QUEUE_INFO_EXT;
                const( void )*      pNext;
                VkQueue             queue;
                MTLCommandQueue_id  mtlCommandQueue;
            }
            
            struct VkExportMetalBufferInfoEXT {
                VkStructureType  sType = VK_STRUCTURE_TYPE_EXPORT_METAL_BUFFER_INFO_EXT;
                const( void )*   pNext;
                VkDeviceMemory   memory;
                MTLBuffer_id     mtlBuffer;
            }
            
            struct VkImportMetalBufferInfoEXT {
                VkStructureType  sType = VK_STRUCTURE_TYPE_IMPORT_METAL_BUFFER_INFO_EXT;
                const( void )*   pNext;
                MTLBuffer_id     mtlBuffer;
            }
            
            struct VkExportMetalTextureInfoEXT {
                VkStructureType        sType = VK_STRUCTURE_TYPE_EXPORT_METAL_TEXTURE_INFO_EXT;
                const( void )*         pNext;
                VkImage                image;
                VkImageView            imageView;
                VkBufferView           bufferView;
                VkImageAspectFlagBits  plane;
                MTLTexture_id          mtlTexture;
            }
            
            struct VkImportMetalTextureInfoEXT {
                VkStructureType        sType = VK_STRUCTURE_TYPE_IMPORT_METAL_TEXTURE_INFO_EXT;
                const( void )*         pNext;
                VkImageAspectFlagBits  plane;
                MTLTexture_id          mtlTexture;
            }
            
            struct VkExportMetalIOSurfaceInfoEXT {
                VkStructureType  sType = VK_STRUCTURE_TYPE_EXPORT_METAL_IO_SURFACE_INFO_EXT;
                const( void )*   pNext;
                VkImage          image;
                IOSurfaceRef     ioSurface;
            }
            
            struct VkImportMetalIOSurfaceInfoEXT {
                VkStructureType  sType = VK_STRUCTURE_TYPE_IMPORT_METAL_IO_SURFACE_INFO_EXT;
                const( void )*   pNext;
                IOSurfaceRef     ioSurface;
            }
            
            struct VkExportMetalSharedEventInfoEXT {
                VkStructureType    sType = VK_STRUCTURE_TYPE_EXPORT_METAL_SHARED_EVENT_INFO_EXT;
                const( void )*     pNext;
                VkSemaphore        semaphore;
                VkEvent            event;
                MTLSharedEvent_id  mtlSharedEvent;
            }
            
            struct VkImportMetalSharedEventInfoEXT {
                VkStructureType    sType = VK_STRUCTURE_TYPE_IMPORT_METAL_SHARED_EVENT_INFO_EXT;
                const( void )*     pNext;
                MTLSharedEvent_id  mtlSharedEvent;
            }
            
            alias PFN_vkExportMetalObjectsEXT                                           = void      function( VkDevice device, VkExportMetalObjectsInfoEXT* pMetalObjectsInfo );
        }

        // VK_NV_acquire_winrt_display : types and function pointer type aliases
        else static if( __traits( isSame, extension, NV_acquire_winrt_display )) {
            enum VK_NV_acquire_winrt_display = 1;

            enum VK_NV_ACQUIRE_WINRT_DISPLAY_SPEC_VERSION = 1;
            enum const( char )* VK_NV_ACQUIRE_WINRT_DISPLAY_EXTENSION_NAME = "VK_NV_acquire_winrt_display";
            
            alias PFN_vkAcquireWinrtDisplayNV                                           = VkResult  function( VkPhysicalDevice physicalDevice, VkDisplayKHR display );
            alias PFN_vkGetWinrtDisplayNV                                               = VkResult  function( VkPhysicalDevice physicalDevice, uint32_t deviceRelativeId, VkDisplayKHR* pDisplay );
        }

        // VK_EXT_directfb_surface : types and function pointer type aliases
        else static if( __traits( isSame, extension, EXT_directfb_surface )) {
            enum VK_EXT_directfb_surface = 1;

            enum VK_EXT_DIRECTFB_SURFACE_SPEC_VERSION = 1;
            enum const( char )* VK_EXT_DIRECTFB_SURFACE_EXTENSION_NAME = "VK_EXT_directfb_surface";
            
            alias VkDirectFBSurfaceCreateFlagsEXT = VkFlags;
            
            struct VkDirectFBSurfaceCreateInfoEXT {
                VkStructureType                  sType = VK_STRUCTURE_TYPE_DIRECTFB_SURFACE_CREATE_INFO_EXT;
                const( void )*                   pNext;
                VkDirectFBSurfaceCreateFlagsEXT  flags;
                IDirectFB*                       dfb;
                IDirectFBSurface*                surface;
            }
            
            alias PFN_vkCreateDirectFBSurfaceEXT                                        = VkResult  function( VkInstance instance, const( VkDirectFBSurfaceCreateInfoEXT )* pCreateInfo, const( VkAllocationCallbacks )* pAllocator, VkSurfaceKHR* pSurface );
            alias PFN_vkGetPhysicalDeviceDirectFBPresentationSupportEXT                 = VkBool32  function( VkPhysicalDevice physicalDevice, uint32_t queueFamilyIndex, IDirectFB* dfb );
        }

        // VK_FUCHSIA_external_memory : types and function pointer type aliases
        else static if( __traits( isSame, extension, FUCHSIA_external_memory )) {
            enum VK_FUCHSIA_external_memory = 1;

            enum VK_FUCHSIA_EXTERNAL_MEMORY_SPEC_VERSION = 1;
            enum const( char )* VK_FUCHSIA_EXTERNAL_MEMORY_EXTENSION_NAME = "VK_FUCHSIA_external_memory";
            
            struct VkImportMemoryZirconHandleInfoFUCHSIA {
                VkStructureType                     sType = VK_STRUCTURE_TYPE_IMPORT_MEMORY_ZIRCON_HANDLE_INFO_FUCHSIA;
                const( void )*                      pNext;
                VkExternalMemoryHandleTypeFlagBits  handleType;
                zx_handle_t                         handle;
            }
            
            struct VkMemoryZirconHandlePropertiesFUCHSIA {
                VkStructureType  sType = VK_STRUCTURE_TYPE_MEMORY_ZIRCON_HANDLE_PROPERTIES_FUCHSIA;
                void*            pNext;
                uint32_t         memoryTypeBits;
            }
            
            struct VkMemoryGetZirconHandleInfoFUCHSIA {
                VkStructureType                     sType = VK_STRUCTURE_TYPE_MEMORY_GET_ZIRCON_HANDLE_INFO_FUCHSIA;
                const( void )*                      pNext;
                VkDeviceMemory                      memory;
                VkExternalMemoryHandleTypeFlagBits  handleType;
            }
            
            alias PFN_vkGetMemoryZirconHandleFUCHSIA                                    = VkResult  function( VkDevice device, const( VkMemoryGetZirconHandleInfoFUCHSIA )* pGetZirconHandleInfo, zx_handle_t* pZirconHandle );
            alias PFN_vkGetMemoryZirconHandlePropertiesFUCHSIA                          = VkResult  function( VkDevice device, VkExternalMemoryHandleTypeFlagBits handleType, zx_handle_t zirconHandle, VkMemoryZirconHandlePropertiesFUCHSIA* pMemoryZirconHandleProperties );
        }

        // VK_FUCHSIA_external_semaphore : types and function pointer type aliases
        else static if( __traits( isSame, extension, FUCHSIA_external_semaphore )) {
            enum VK_FUCHSIA_external_semaphore = 1;

            enum VK_FUCHSIA_EXTERNAL_SEMAPHORE_SPEC_VERSION = 1;
            enum const( char )* VK_FUCHSIA_EXTERNAL_SEMAPHORE_EXTENSION_NAME = "VK_FUCHSIA_external_semaphore";
            
            struct VkImportSemaphoreZirconHandleInfoFUCHSIA {
                VkStructureType                        sType = VK_STRUCTURE_TYPE_IMPORT_SEMAPHORE_ZIRCON_HANDLE_INFO_FUCHSIA;
                const( void )*                         pNext;
                VkSemaphore                            semaphore;
                VkSemaphoreImportFlags                 flags;
                VkExternalSemaphoreHandleTypeFlagBits  handleType;
                zx_handle_t                            zirconHandle;
            }
            
            struct VkSemaphoreGetZirconHandleInfoFUCHSIA {
                VkStructureType                        sType = VK_STRUCTURE_TYPE_SEMAPHORE_GET_ZIRCON_HANDLE_INFO_FUCHSIA;
                const( void )*                         pNext;
                VkSemaphore                            semaphore;
                VkExternalSemaphoreHandleTypeFlagBits  handleType;
            }
            
            alias PFN_vkImportSemaphoreZirconHandleFUCHSIA                              = VkResult  function( VkDevice device, const( VkImportSemaphoreZirconHandleInfoFUCHSIA )* pImportSemaphoreZirconHandleInfo );
            alias PFN_vkGetSemaphoreZirconHandleFUCHSIA                                 = VkResult  function( VkDevice device, const( VkSemaphoreGetZirconHandleInfoFUCHSIA )* pGetZirconHandleInfo, zx_handle_t* pZirconHandle );
        }

        // VK_FUCHSIA_buffer_collection : types and function pointer type aliases
        else static if( __traits( isSame, extension, FUCHSIA_buffer_collection )) {
            enum VK_FUCHSIA_buffer_collection = 1;

            mixin( VK_DEFINE_NON_DISPATCHABLE_HANDLE!q{VkBufferCollectionFUCHSIA} );
            
            enum VK_FUCHSIA_BUFFER_COLLECTION_SPEC_VERSION = 2;
            enum const( char )* VK_FUCHSIA_BUFFER_COLLECTION_EXTENSION_NAME = "VK_FUCHSIA_buffer_collection";
            
            alias VkImageFormatConstraintsFlagsFUCHSIA = VkFlags;
            
            alias VkImageConstraintsInfoFlagsFUCHSIA = VkFlags;
            enum VkImageConstraintsInfoFlagBitsFUCHSIA : VkImageConstraintsInfoFlagsFUCHSIA {
                VK_IMAGE_CONSTRAINTS_INFO_CPU_READ_RARELY_FUCHSIA            = 0x00000001,
                VK_IMAGE_CONSTRAINTS_INFO_CPU_READ_OFTEN_FUCHSIA             = 0x00000002,
                VK_IMAGE_CONSTRAINTS_INFO_CPU_WRITE_RARELY_FUCHSIA           = 0x00000004,
                VK_IMAGE_CONSTRAINTS_INFO_CPU_WRITE_OFTEN_FUCHSIA            = 0x00000008,
                VK_IMAGE_CONSTRAINTS_INFO_PROTECTED_OPTIONAL_FUCHSIA         = 0x00000010,
                VK_IMAGE_CONSTRAINTS_INFO_FLAG_BITS_MAX_ENUM_FUCHSIA         = 0x7FFFFFFF
            }
            
            enum VK_IMAGE_CONSTRAINTS_INFO_CPU_READ_RARELY_FUCHSIA           = VkImageConstraintsInfoFlagBitsFUCHSIA.VK_IMAGE_CONSTRAINTS_INFO_CPU_READ_RARELY_FUCHSIA;
            enum VK_IMAGE_CONSTRAINTS_INFO_CPU_READ_OFTEN_FUCHSIA            = VkImageConstraintsInfoFlagBitsFUCHSIA.VK_IMAGE_CONSTRAINTS_INFO_CPU_READ_OFTEN_FUCHSIA;
            enum VK_IMAGE_CONSTRAINTS_INFO_CPU_WRITE_RARELY_FUCHSIA          = VkImageConstraintsInfoFlagBitsFUCHSIA.VK_IMAGE_CONSTRAINTS_INFO_CPU_WRITE_RARELY_FUCHSIA;
            enum VK_IMAGE_CONSTRAINTS_INFO_CPU_WRITE_OFTEN_FUCHSIA           = VkImageConstraintsInfoFlagBitsFUCHSIA.VK_IMAGE_CONSTRAINTS_INFO_CPU_WRITE_OFTEN_FUCHSIA;
            enum VK_IMAGE_CONSTRAINTS_INFO_PROTECTED_OPTIONAL_FUCHSIA        = VkImageConstraintsInfoFlagBitsFUCHSIA.VK_IMAGE_CONSTRAINTS_INFO_PROTECTED_OPTIONAL_FUCHSIA;
            enum VK_IMAGE_CONSTRAINTS_INFO_FLAG_BITS_MAX_ENUM_FUCHSIA        = VkImageConstraintsInfoFlagBitsFUCHSIA.VK_IMAGE_CONSTRAINTS_INFO_FLAG_BITS_MAX_ENUM_FUCHSIA;
            
            struct VkBufferCollectionCreateInfoFUCHSIA {
                VkStructureType  sType = VK_STRUCTURE_TYPE_BUFFER_COLLECTION_CREATE_INFO_FUCHSIA;
                const( void )*   pNext;
                zx_handle_t      collectionToken;
            }
            
            struct VkImportMemoryBufferCollectionFUCHSIA {
                VkStructureType            sType = VK_STRUCTURE_TYPE_IMPORT_MEMORY_BUFFER_COLLECTION_FUCHSIA;
                const( void )*             pNext;
                VkBufferCollectionFUCHSIA  collection;
                uint32_t                   index;
            }
            
            struct VkBufferCollectionImageCreateInfoFUCHSIA {
                VkStructureType            sType = VK_STRUCTURE_TYPE_BUFFER_COLLECTION_IMAGE_CREATE_INFO_FUCHSIA;
                const( void )*             pNext;
                VkBufferCollectionFUCHSIA  collection;
                uint32_t                   index;
            }
            
            struct VkBufferCollectionConstraintsInfoFUCHSIA {
                VkStructureType  sType = VK_STRUCTURE_TYPE_BUFFER_COLLECTION_CONSTRAINTS_INFO_FUCHSIA;
                const( void )*   pNext;
                uint32_t         minBufferCount;
                uint32_t         maxBufferCount;
                uint32_t         minBufferCountForCamping;
                uint32_t         minBufferCountForDedicatedSlack;
                uint32_t         minBufferCountForSharedSlack;
            }
            
            struct VkBufferConstraintsInfoFUCHSIA {
                VkStructureType                           sType = VK_STRUCTURE_TYPE_BUFFER_CONSTRAINTS_INFO_FUCHSIA;
                const( void )*                            pNext;
                VkBufferCreateInfo                        createInfo;
                VkFormatFeatureFlags                      requiredFormatFeatures;
                VkBufferCollectionConstraintsInfoFUCHSIA  bufferCollectionConstraints;
            }
            
            struct VkBufferCollectionBufferCreateInfoFUCHSIA {
                VkStructureType            sType = VK_STRUCTURE_TYPE_BUFFER_COLLECTION_BUFFER_CREATE_INFO_FUCHSIA;
                const( void )*             pNext;
                VkBufferCollectionFUCHSIA  collection;
                uint32_t                   index;
            }
            
            struct VkSysmemColorSpaceFUCHSIA {
                VkStructureType  sType = VK_STRUCTURE_TYPE_SYSMEM_COLOR_SPACE_FUCHSIA;
                const( void )*   pNext;
                uint32_t         colorSpace;
            }
            
            struct VkBufferCollectionPropertiesFUCHSIA {
                VkStructureType                sType = VK_STRUCTURE_TYPE_BUFFER_COLLECTION_PROPERTIES_FUCHSIA;
                void*                          pNext;
                uint32_t                       memoryTypeBits;
                uint32_t                       bufferCount;
                uint32_t                       createInfoIndex;
                uint64_t                       sysmemPixelFormat;
                VkFormatFeatureFlags           formatFeatures;
                VkSysmemColorSpaceFUCHSIA      sysmemColorSpaceIndex;
                VkComponentMapping             samplerYcbcrConversionComponents;
                VkSamplerYcbcrModelConversion  suggestedYcbcrModel;
                VkSamplerYcbcrRange            suggestedYcbcrRange;
                VkChromaLocation               suggestedXChromaOffset;
                VkChromaLocation               suggestedYChromaOffset;
            }
            
            struct VkImageFormatConstraintsInfoFUCHSIA {
                VkStructureType                       sType = VK_STRUCTURE_TYPE_IMAGE_FORMAT_CONSTRAINTS_INFO_FUCHSIA;
                const( void )*                        pNext;
                VkImageCreateInfo                     imageCreateInfo;
                VkFormatFeatureFlags                  requiredFormatFeatures;
                VkImageFormatConstraintsFlagsFUCHSIA  flags;
                uint64_t                              sysmemPixelFormat;
                uint32_t                              colorSpaceCount;
                const( VkSysmemColorSpaceFUCHSIA )*   pColorSpaces;
            }
            
            struct VkImageConstraintsInfoFUCHSIA {
                VkStructureType                                sType = VK_STRUCTURE_TYPE_IMAGE_CONSTRAINTS_INFO_FUCHSIA;
                const( void )*                                 pNext;
                uint32_t                                       formatConstraintsCount;
                const( VkImageFormatConstraintsInfoFUCHSIA )*  pFormatConstraints;
                VkBufferCollectionConstraintsInfoFUCHSIA       bufferCollectionConstraints;
                VkImageConstraintsInfoFlagsFUCHSIA             flags;
            }
            
            alias PFN_vkCreateBufferCollectionFUCHSIA                                   = VkResult  function( VkDevice device, const( VkBufferCollectionCreateInfoFUCHSIA )* pCreateInfo, const( VkAllocationCallbacks )* pAllocator, VkBufferCollectionFUCHSIA* pCollection );
            alias PFN_vkSetBufferCollectionImageConstraintsFUCHSIA                      = VkResult  function( VkDevice device, VkBufferCollectionFUCHSIA collection, const( VkImageConstraintsInfoFUCHSIA )* pImageConstraintsInfo );
            alias PFN_vkSetBufferCollectionBufferConstraintsFUCHSIA                     = VkResult  function( VkDevice device, VkBufferCollectionFUCHSIA collection, const( VkBufferConstraintsInfoFUCHSIA )* pBufferConstraintsInfo );
            alias PFN_vkDestroyBufferCollectionFUCHSIA                                  = void      function( VkDevice device, VkBufferCollectionFUCHSIA collection, const( VkAllocationCallbacks )* pAllocator );
            alias PFN_vkGetBufferCollectionPropertiesFUCHSIA                            = VkResult  function( VkDevice device, VkBufferCollectionFUCHSIA collection, VkBufferCollectionPropertiesFUCHSIA* pProperties );
        }

        // VK_QNX_screen_surface : types and function pointer type aliases
        else static if( __traits( isSame, extension, QNX_screen_surface )) {
            enum VK_QNX_screen_surface = 1;

            enum VK_QNX_SCREEN_SURFACE_SPEC_VERSION = 1;
            enum const( char )* VK_QNX_SCREEN_SURFACE_EXTENSION_NAME = "VK_QNX_screen_surface";
            
            alias VkScreenSurfaceCreateFlagsQNX = VkFlags;
            
            struct VkScreenSurfaceCreateInfoQNX {
                VkStructureType                sType = VK_STRUCTURE_TYPE_SCREEN_SURFACE_CREATE_INFO_QNX;
                const( void )*                 pNext;
                VkScreenSurfaceCreateFlagsQNX  flags;
                const( _screen_context )*      context;
                const( _screen_window )*       window;
            }
            
            alias PFN_vkCreateScreenSurfaceQNX                                          = VkResult  function( VkInstance instance, const( VkScreenSurfaceCreateInfoQNX )* pCreateInfo, const( VkAllocationCallbacks )* pAllocator, VkSurfaceKHR* pSurface );
            alias PFN_vkGetPhysicalDeviceScreenPresentationSupportQNX                   = VkBool32  function( VkPhysicalDevice physicalDevice, uint32_t queueFamilyIndex, const( _screen_window )* window );
        }

        // VK_NV_displacement_micromap : types and function pointer type aliases
        else static if( __traits( isSame, extension, NV_displacement_micromap )) {
            enum VK_NV_displacement_micromap = 1;

            enum VK_NV_DISPLACEMENT_MICROMAP_SPEC_VERSION = 1;
            enum const( char )* VK_NV_DISPLACEMENT_MICROMAP_EXTENSION_NAME = "VK_NV_displacement_micromap";
            
            enum VkDisplacementMicromapFormatNV {
                VK_DISPLACEMENT_MICROMAP_FORMAT_64_TRIANGLES_64_BYTES_NV     = 1,
                VK_DISPLACEMENT_MICROMAP_FORMAT_256_TRIANGLES_128_BYTES_NV   = 2,
                VK_DISPLACEMENT_MICROMAP_FORMAT_1024_TRIANGLES_128_BYTES_NV  = 3,
                VK_DISPLACEMENT_MICROMAP_FORMAT_MAX_ENUM_NV                  = 0x7FFFFFFF
            }
            
            enum VK_DISPLACEMENT_MICROMAP_FORMAT_64_TRIANGLES_64_BYTES_NV    = VkDisplacementMicromapFormatNV.VK_DISPLACEMENT_MICROMAP_FORMAT_64_TRIANGLES_64_BYTES_NV;
            enum VK_DISPLACEMENT_MICROMAP_FORMAT_256_TRIANGLES_128_BYTES_NV  = VkDisplacementMicromapFormatNV.VK_DISPLACEMENT_MICROMAP_FORMAT_256_TRIANGLES_128_BYTES_NV;
            enum VK_DISPLACEMENT_MICROMAP_FORMAT_1024_TRIANGLES_128_BYTES_NV = VkDisplacementMicromapFormatNV.VK_DISPLACEMENT_MICROMAP_FORMAT_1024_TRIANGLES_128_BYTES_NV;
            enum VK_DISPLACEMENT_MICROMAP_FORMAT_MAX_ENUM_NV                 = VkDisplacementMicromapFormatNV.VK_DISPLACEMENT_MICROMAP_FORMAT_MAX_ENUM_NV;
            
            struct VkPhysicalDeviceDisplacementMicromapFeaturesNV {
                VkStructureType  sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DISPLACEMENT_MICROMAP_FEATURES_NV;
                void*            pNext;
                VkBool32         displacementMicromap;
            }
            
            struct VkPhysicalDeviceDisplacementMicromapPropertiesNV {
                VkStructureType  sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DISPLACEMENT_MICROMAP_PROPERTIES_NV;
                void*            pNext;
                uint32_t         maxDisplacementMicromapSubdivisionLevel;
            }
            
            struct VkAccelerationStructureTrianglesDisplacementMicromapNV {
                VkStructureType                sType = VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_TRIANGLES_DISPLACEMENT_MICROMAP_NV;
                void*                          pNext;
                VkFormat                       displacementBiasAndScaleFormat;
                VkFormat                       displacementVectorFormat;
                VkDeviceOrHostAddressConstKHR  displacementBiasAndScaleBuffer;
                VkDeviceSize                   displacementBiasAndScaleStride;
                VkDeviceOrHostAddressConstKHR  displacementVectorBuffer;
                VkDeviceSize                   displacementVectorStride;
                VkDeviceOrHostAddressConstKHR  displacedMicromapPrimitiveFlags;
                VkDeviceSize                   displacedMicromapPrimitiveFlagsStride;
                VkIndexType                    indexType;
                VkDeviceOrHostAddressConstKHR  indexBuffer;
                VkDeviceSize                   indexStride;
                uint32_t                       baseTriangle;
                uint32_t                       usageCountsCount;
                const( VkMicromapUsageEXT )*   pUsageCounts;
                const( VkMicromapUsageEXT* )*  ppUsageCounts;
                VkMicromapEXT                  micromap;
            }
            
        }

        __gshared {

            // VK_KHR_xlib_surface : function pointer decelerations
            static if( __traits( isSame, extension, KHR_xlib_surface )) {
                PFN_vkCreateXlibSurfaceKHR                                            vkCreateXlibSurfaceKHR;
                PFN_vkGetPhysicalDeviceXlibPresentationSupportKHR                     vkGetPhysicalDeviceXlibPresentationSupportKHR;
            }

            // VK_KHR_xcb_surface : function pointer decelerations
            else static if( __traits( isSame, extension, KHR_xcb_surface )) {
                PFN_vkCreateXcbSurfaceKHR                                             vkCreateXcbSurfaceKHR;
                PFN_vkGetPhysicalDeviceXcbPresentationSupportKHR                      vkGetPhysicalDeviceXcbPresentationSupportKHR;
            }

            // VK_KHR_wayland_surface : function pointer decelerations
            else static if( __traits( isSame, extension, KHR_wayland_surface )) {
                PFN_vkCreateWaylandSurfaceKHR                                         vkCreateWaylandSurfaceKHR;
                PFN_vkGetPhysicalDeviceWaylandPresentationSupportKHR                  vkGetPhysicalDeviceWaylandPresentationSupportKHR;
            }

            // VK_KHR_android_surface : function pointer decelerations
            else static if( __traits( isSame, extension, KHR_android_surface )) {
                PFN_vkCreateAndroidSurfaceKHR                                         vkCreateAndroidSurfaceKHR;
            }

            // VK_KHR_win32_surface : function pointer decelerations
            else static if( __traits( isSame, extension, KHR_win32_surface )) {
                PFN_vkCreateWin32SurfaceKHR                                           vkCreateWin32SurfaceKHR;
                PFN_vkGetPhysicalDeviceWin32PresentationSupportKHR                    vkGetPhysicalDeviceWin32PresentationSupportKHR;
            }

            // VK_KHR_external_memory_win32 : function pointer decelerations
            else static if( __traits( isSame, extension, KHR_external_memory_win32 )) {
                PFN_vkGetMemoryWin32HandleKHR                                         vkGetMemoryWin32HandleKHR;
                PFN_vkGetMemoryWin32HandlePropertiesKHR                               vkGetMemoryWin32HandlePropertiesKHR;
            }

            // VK_KHR_external_semaphore_win32 : function pointer decelerations
            else static if( __traits( isSame, extension, KHR_external_semaphore_win32 )) {
                PFN_vkImportSemaphoreWin32HandleKHR                                   vkImportSemaphoreWin32HandleKHR;
                PFN_vkGetSemaphoreWin32HandleKHR                                      vkGetSemaphoreWin32HandleKHR;
            }

            // VK_KHR_external_fence_win32 : function pointer decelerations
            else static if( __traits( isSame, extension, KHR_external_fence_win32 )) {
                PFN_vkImportFenceWin32HandleKHR                                       vkImportFenceWin32HandleKHR;
                PFN_vkGetFenceWin32HandleKHR                                          vkGetFenceWin32HandleKHR;
            }

            // VK_KHR_video_encode_queue : function pointer decelerations
            else static if( __traits( isSame, extension, KHR_video_encode_queue )) {
                PFN_vkCmdEncodeVideoKHR                                               vkCmdEncodeVideoKHR;
            }

            // VK_GGP_stream_descriptor_surface : function pointer decelerations
            else static if( __traits( isSame, extension, GGP_stream_descriptor_surface )) {
                PFN_vkCreateStreamDescriptorSurfaceGGP                                vkCreateStreamDescriptorSurfaceGGP;
            }

            // VK_NV_external_memory_win32 : function pointer decelerations
            else static if( __traits( isSame, extension, NV_external_memory_win32 )) {
                PFN_vkGetMemoryWin32HandleNV                                          vkGetMemoryWin32HandleNV;
            }

            // VK_NN_vi_surface : function pointer decelerations
            else static if( __traits( isSame, extension, NN_vi_surface )) {
                PFN_vkCreateViSurfaceNN                                               vkCreateViSurfaceNN;
            }

            // VK_EXT_acquire_xlib_display : function pointer decelerations
            else static if( __traits( isSame, extension, EXT_acquire_xlib_display )) {
                PFN_vkAcquireXlibDisplayEXT                                           vkAcquireXlibDisplayEXT;
                PFN_vkGetRandROutputDisplayEXT                                        vkGetRandROutputDisplayEXT;
            }

            // VK_MVK_ios_surface : function pointer decelerations
            else static if( __traits( isSame, extension, MVK_ios_surface )) {
                PFN_vkCreateIOSSurfaceMVK                                             vkCreateIOSSurfaceMVK;
            }

            // VK_MVK_macos_surface : function pointer decelerations
            else static if( __traits( isSame, extension, MVK_macos_surface )) {
                PFN_vkCreateMacOSSurfaceMVK                                           vkCreateMacOSSurfaceMVK;
            }

            // VK_ANDROID_external_memory_android_hardware_buffer : function pointer decelerations
            else static if( __traits( isSame, extension, ANDROID_external_memory_android_hardware_buffer )) {
                PFN_vkGetAndroidHardwareBufferPropertiesANDROID                       vkGetAndroidHardwareBufferPropertiesANDROID;
                PFN_vkGetMemoryAndroidHardwareBufferANDROID                           vkGetMemoryAndroidHardwareBufferANDROID;
            }

            // VK_FUCHSIA_imagepipe_surface : function pointer decelerations
            else static if( __traits( isSame, extension, FUCHSIA_imagepipe_surface )) {
                PFN_vkCreateImagePipeSurfaceFUCHSIA                                   vkCreateImagePipeSurfaceFUCHSIA;
            }

            // VK_EXT_metal_surface : function pointer decelerations
            else static if( __traits( isSame, extension, EXT_metal_surface )) {
                PFN_vkCreateMetalSurfaceEXT                                           vkCreateMetalSurfaceEXT;
            }

            // VK_EXT_full_screen_exclusive : function pointer decelerations
            else static if( __traits( isSame, extension, EXT_full_screen_exclusive )) {
                PFN_vkGetPhysicalDeviceSurfacePresentModes2EXT                        vkGetPhysicalDeviceSurfacePresentModes2EXT;
                PFN_vkAcquireFullScreenExclusiveModeEXT                               vkAcquireFullScreenExclusiveModeEXT;
                PFN_vkReleaseFullScreenExclusiveModeEXT                               vkReleaseFullScreenExclusiveModeEXT;
                PFN_vkGetDeviceGroupSurfacePresentModes2EXT                           vkGetDeviceGroupSurfacePresentModes2EXT;
            }

            // VK_EXT_metal_objects : function pointer decelerations
            else static if( __traits( isSame, extension, EXT_metal_objects )) {
                PFN_vkExportMetalObjectsEXT                                           vkExportMetalObjectsEXT;
            }

            // VK_NV_acquire_winrt_display : function pointer decelerations
            else static if( __traits( isSame, extension, NV_acquire_winrt_display )) {
                PFN_vkAcquireWinrtDisplayNV                                           vkAcquireWinrtDisplayNV;
                PFN_vkGetWinrtDisplayNV                                               vkGetWinrtDisplayNV;
            }

            // VK_EXT_directfb_surface : function pointer decelerations
            else static if( __traits( isSame, extension, EXT_directfb_surface )) {
                PFN_vkCreateDirectFBSurfaceEXT                                        vkCreateDirectFBSurfaceEXT;
                PFN_vkGetPhysicalDeviceDirectFBPresentationSupportEXT                 vkGetPhysicalDeviceDirectFBPresentationSupportEXT;
            }

            // VK_FUCHSIA_external_memory : function pointer decelerations
            else static if( __traits( isSame, extension, FUCHSIA_external_memory )) {
                PFN_vkGetMemoryZirconHandleFUCHSIA                                    vkGetMemoryZirconHandleFUCHSIA;
                PFN_vkGetMemoryZirconHandlePropertiesFUCHSIA                          vkGetMemoryZirconHandlePropertiesFUCHSIA;
            }

            // VK_FUCHSIA_external_semaphore : function pointer decelerations
            else static if( __traits( isSame, extension, FUCHSIA_external_semaphore )) {
                PFN_vkImportSemaphoreZirconHandleFUCHSIA                              vkImportSemaphoreZirconHandleFUCHSIA;
                PFN_vkGetSemaphoreZirconHandleFUCHSIA                                 vkGetSemaphoreZirconHandleFUCHSIA;
            }

            // VK_FUCHSIA_buffer_collection : function pointer decelerations
            else static if( __traits( isSame, extension, FUCHSIA_buffer_collection )) {
                PFN_vkCreateBufferCollectionFUCHSIA                                   vkCreateBufferCollectionFUCHSIA;
                PFN_vkSetBufferCollectionImageConstraintsFUCHSIA                      vkSetBufferCollectionImageConstraintsFUCHSIA;
                PFN_vkSetBufferCollectionBufferConstraintsFUCHSIA                     vkSetBufferCollectionBufferConstraintsFUCHSIA;
                PFN_vkDestroyBufferCollectionFUCHSIA                                  vkDestroyBufferCollectionFUCHSIA;
                PFN_vkGetBufferCollectionPropertiesFUCHSIA                            vkGetBufferCollectionPropertiesFUCHSIA;
            }

            // VK_QNX_screen_surface : function pointer decelerations
            else static if( __traits( isSame, extension, QNX_screen_surface )) {
                PFN_vkCreateScreenSurfaceQNX                                          vkCreateScreenSurfaceQNX;
                PFN_vkGetPhysicalDeviceScreenPresentationSupportQNX                   vkGetPhysicalDeviceScreenPresentationSupportQNX;
            }
        }
    }

    // workaround for not being able to mixin two overloads with the same symbol name
    alias loadDeviceLevelFunctionsExt = loadDeviceLevelFunctionsExtI;
    alias loadDeviceLevelFunctionsExt = loadDeviceLevelFunctionsExtD;

    // backwards compatibility aliases
    alias loadInstanceLevelFunctions = loadInstanceLevelFunctionsExt;
    alias loadDeviceLevelFunctions = loadDeviceLevelFunctionsExt;
    alias DispatchDevice = DispatchDeviceExt;

    // compose loadInstanceLevelFunctionsExt function out of unextended
    // loadInstanceLevelFunctions and additional function pointers from extensions
    void loadInstanceLevelFunctionsExt( VkInstance instance ) {

        // first load all non platform related function pointers from implementation
        erupted.functions.loadInstanceLevelFunctions( instance );

        // 2. loop through alias sequence and mixin corresponding
        // instance level function pointer definitions
        static foreach( extension; noDuplicateExtensions ) {

            // VK_KHR_xlib_surface : load instance level function definitions
            static if( __traits( isSame, extension, KHR_xlib_surface )) {
                vkCreateXlibSurfaceKHR                                            = cast( PFN_vkCreateXlibSurfaceKHR                                            ) vkGetInstanceProcAddr( instance, "vkCreateXlibSurfaceKHR" );
                vkGetPhysicalDeviceXlibPresentationSupportKHR                     = cast( PFN_vkGetPhysicalDeviceXlibPresentationSupportKHR                     ) vkGetInstanceProcAddr( instance, "vkGetPhysicalDeviceXlibPresentationSupportKHR" );
            }

            // VK_KHR_xcb_surface : load instance level function definitions
            else static if( __traits( isSame, extension, KHR_xcb_surface )) {
                vkCreateXcbSurfaceKHR                                             = cast( PFN_vkCreateXcbSurfaceKHR                                             ) vkGetInstanceProcAddr( instance, "vkCreateXcbSurfaceKHR" );
                vkGetPhysicalDeviceXcbPresentationSupportKHR                      = cast( PFN_vkGetPhysicalDeviceXcbPresentationSupportKHR                      ) vkGetInstanceProcAddr( instance, "vkGetPhysicalDeviceXcbPresentationSupportKHR" );
            }

            // VK_KHR_wayland_surface : load instance level function definitions
            else static if( __traits( isSame, extension, KHR_wayland_surface )) {
                vkCreateWaylandSurfaceKHR                                         = cast( PFN_vkCreateWaylandSurfaceKHR                                         ) vkGetInstanceProcAddr( instance, "vkCreateWaylandSurfaceKHR" );
                vkGetPhysicalDeviceWaylandPresentationSupportKHR                  = cast( PFN_vkGetPhysicalDeviceWaylandPresentationSupportKHR                  ) vkGetInstanceProcAddr( instance, "vkGetPhysicalDeviceWaylandPresentationSupportKHR" );
            }

            // VK_KHR_android_surface : load instance level function definitions
            else static if( __traits( isSame, extension, KHR_android_surface )) {
                vkCreateAndroidSurfaceKHR                                         = cast( PFN_vkCreateAndroidSurfaceKHR                                         ) vkGetInstanceProcAddr( instance, "vkCreateAndroidSurfaceKHR" );
            }

            // VK_KHR_win32_surface : load instance level function definitions
            else static if( __traits( isSame, extension, KHR_win32_surface )) {
                vkCreateWin32SurfaceKHR                                           = cast( PFN_vkCreateWin32SurfaceKHR                                           ) vkGetInstanceProcAddr( instance, "vkCreateWin32SurfaceKHR" );
                vkGetPhysicalDeviceWin32PresentationSupportKHR                    = cast( PFN_vkGetPhysicalDeviceWin32PresentationSupportKHR                    ) vkGetInstanceProcAddr( instance, "vkGetPhysicalDeviceWin32PresentationSupportKHR" );
            }

            // VK_GGP_stream_descriptor_surface : load instance level function definitions
            else static if( __traits( isSame, extension, GGP_stream_descriptor_surface )) {
                vkCreateStreamDescriptorSurfaceGGP                                = cast( PFN_vkCreateStreamDescriptorSurfaceGGP                                ) vkGetInstanceProcAddr( instance, "vkCreateStreamDescriptorSurfaceGGP" );
            }

            // VK_NN_vi_surface : load instance level function definitions
            else static if( __traits( isSame, extension, NN_vi_surface )) {
                vkCreateViSurfaceNN                                               = cast( PFN_vkCreateViSurfaceNN                                               ) vkGetInstanceProcAddr( instance, "vkCreateViSurfaceNN" );
            }

            // VK_EXT_acquire_xlib_display : load instance level function definitions
            else static if( __traits( isSame, extension, EXT_acquire_xlib_display )) {
                vkAcquireXlibDisplayEXT                                           = cast( PFN_vkAcquireXlibDisplayEXT                                           ) vkGetInstanceProcAddr( instance, "vkAcquireXlibDisplayEXT" );
                vkGetRandROutputDisplayEXT                                        = cast( PFN_vkGetRandROutputDisplayEXT                                        ) vkGetInstanceProcAddr( instance, "vkGetRandROutputDisplayEXT" );
            }

            // VK_MVK_ios_surface : load instance level function definitions
            else static if( __traits( isSame, extension, MVK_ios_surface )) {
                vkCreateIOSSurfaceMVK                                             = cast( PFN_vkCreateIOSSurfaceMVK                                             ) vkGetInstanceProcAddr( instance, "vkCreateIOSSurfaceMVK" );
            }

            // VK_MVK_macos_surface : load instance level function definitions
            else static if( __traits( isSame, extension, MVK_macos_surface )) {
                vkCreateMacOSSurfaceMVK                                           = cast( PFN_vkCreateMacOSSurfaceMVK                                           ) vkGetInstanceProcAddr( instance, "vkCreateMacOSSurfaceMVK" );
            }

            // VK_FUCHSIA_imagepipe_surface : load instance level function definitions
            else static if( __traits( isSame, extension, FUCHSIA_imagepipe_surface )) {
                vkCreateImagePipeSurfaceFUCHSIA                                   = cast( PFN_vkCreateImagePipeSurfaceFUCHSIA                                   ) vkGetInstanceProcAddr( instance, "vkCreateImagePipeSurfaceFUCHSIA" );
            }

            // VK_EXT_metal_surface : load instance level function definitions
            else static if( __traits( isSame, extension, EXT_metal_surface )) {
                vkCreateMetalSurfaceEXT                                           = cast( PFN_vkCreateMetalSurfaceEXT                                           ) vkGetInstanceProcAddr( instance, "vkCreateMetalSurfaceEXT" );
            }

            // VK_EXT_full_screen_exclusive : load instance level function definitions
            else static if( __traits( isSame, extension, EXT_full_screen_exclusive )) {
                vkGetPhysicalDeviceSurfacePresentModes2EXT                        = cast( PFN_vkGetPhysicalDeviceSurfacePresentModes2EXT                        ) vkGetInstanceProcAddr( instance, "vkGetPhysicalDeviceSurfacePresentModes2EXT" );
            }

            // VK_NV_acquire_winrt_display : load instance level function definitions
            else static if( __traits( isSame, extension, NV_acquire_winrt_display )) {
                vkAcquireWinrtDisplayNV                                           = cast( PFN_vkAcquireWinrtDisplayNV                                           ) vkGetInstanceProcAddr( instance, "vkAcquireWinrtDisplayNV" );
                vkGetWinrtDisplayNV                                               = cast( PFN_vkGetWinrtDisplayNV                                               ) vkGetInstanceProcAddr( instance, "vkGetWinrtDisplayNV" );
            }

            // VK_EXT_directfb_surface : load instance level function definitions
            else static if( __traits( isSame, extension, EXT_directfb_surface )) {
                vkCreateDirectFBSurfaceEXT                                        = cast( PFN_vkCreateDirectFBSurfaceEXT                                        ) vkGetInstanceProcAddr( instance, "vkCreateDirectFBSurfaceEXT" );
                vkGetPhysicalDeviceDirectFBPresentationSupportEXT                 = cast( PFN_vkGetPhysicalDeviceDirectFBPresentationSupportEXT                 ) vkGetInstanceProcAddr( instance, "vkGetPhysicalDeviceDirectFBPresentationSupportEXT" );
            }

            // VK_QNX_screen_surface : load instance level function definitions
            else static if( __traits( isSame, extension, QNX_screen_surface )) {
                vkCreateScreenSurfaceQNX                                          = cast( PFN_vkCreateScreenSurfaceQNX                                          ) vkGetInstanceProcAddr( instance, "vkCreateScreenSurfaceQNX" );
                vkGetPhysicalDeviceScreenPresentationSupportQNX                   = cast( PFN_vkGetPhysicalDeviceScreenPresentationSupportQNX                   ) vkGetInstanceProcAddr( instance, "vkGetPhysicalDeviceScreenPresentationSupportQNX" );
            }
        }
    }

    // compose instance based loadDeviceLevelFunctionsExtI function out of unextended
    // loadDeviceLevelFunctions and additional function pointers from extensions
    // suffix I is required, as we cannot mixin mixin two overloads with the same symbol name (any more!)
    void loadDeviceLevelFunctionsExtI( VkInstance instance ) {

        // first load all non platform related function pointers from implementation
        erupted.functions.loadDeviceLevelFunctions( instance );

        // 3. loop through alias sequence and mixin corresponding
        // instance based device level function pointer definitions
        static foreach( extension; noDuplicateExtensions ) {

            // VK_KHR_external_memory_win32 : load instance based device level function definitions
            static if( __traits( isSame, extension, KHR_external_memory_win32 )) {
                vkGetMemoryWin32HandleKHR                                = cast( PFN_vkGetMemoryWin32HandleKHR                                ) vkGetInstanceProcAddr( instance, "vkGetMemoryWin32HandleKHR" );
                vkGetMemoryWin32HandlePropertiesKHR                      = cast( PFN_vkGetMemoryWin32HandlePropertiesKHR                      ) vkGetInstanceProcAddr( instance, "vkGetMemoryWin32HandlePropertiesKHR" );
            }

            // VK_KHR_external_semaphore_win32 : load instance based device level function definitions
            else static if( __traits( isSame, extension, KHR_external_semaphore_win32 )) {
                vkImportSemaphoreWin32HandleKHR                          = cast( PFN_vkImportSemaphoreWin32HandleKHR                          ) vkGetInstanceProcAddr( instance, "vkImportSemaphoreWin32HandleKHR" );
                vkGetSemaphoreWin32HandleKHR                             = cast( PFN_vkGetSemaphoreWin32HandleKHR                             ) vkGetInstanceProcAddr( instance, "vkGetSemaphoreWin32HandleKHR" );
            }

            // VK_KHR_external_fence_win32 : load instance based device level function definitions
            else static if( __traits( isSame, extension, KHR_external_fence_win32 )) {
                vkImportFenceWin32HandleKHR                              = cast( PFN_vkImportFenceWin32HandleKHR                              ) vkGetInstanceProcAddr( instance, "vkImportFenceWin32HandleKHR" );
                vkGetFenceWin32HandleKHR                                 = cast( PFN_vkGetFenceWin32HandleKHR                                 ) vkGetInstanceProcAddr( instance, "vkGetFenceWin32HandleKHR" );
            }

            // VK_KHR_video_encode_queue : load instance based device level function definitions
            else static if( __traits( isSame, extension, KHR_video_encode_queue )) {
                vkCmdEncodeVideoKHR                                      = cast( PFN_vkCmdEncodeVideoKHR                                      ) vkGetInstanceProcAddr( instance, "vkCmdEncodeVideoKHR" );
            }

            // VK_NV_external_memory_win32 : load instance based device level function definitions
            else static if( __traits( isSame, extension, NV_external_memory_win32 )) {
                vkGetMemoryWin32HandleNV                                 = cast( PFN_vkGetMemoryWin32HandleNV                                 ) vkGetInstanceProcAddr( instance, "vkGetMemoryWin32HandleNV" );
            }

            // VK_ANDROID_external_memory_android_hardware_buffer : load instance based device level function definitions
            else static if( __traits( isSame, extension, ANDROID_external_memory_android_hardware_buffer )) {
                vkGetAndroidHardwareBufferPropertiesANDROID              = cast( PFN_vkGetAndroidHardwareBufferPropertiesANDROID              ) vkGetInstanceProcAddr( instance, "vkGetAndroidHardwareBufferPropertiesANDROID" );
                vkGetMemoryAndroidHardwareBufferANDROID                  = cast( PFN_vkGetMemoryAndroidHardwareBufferANDROID                  ) vkGetInstanceProcAddr( instance, "vkGetMemoryAndroidHardwareBufferANDROID" );
            }

            // VK_EXT_full_screen_exclusive : load instance based device level function definitions
            else static if( __traits( isSame, extension, EXT_full_screen_exclusive )) {
                vkAcquireFullScreenExclusiveModeEXT                      = cast( PFN_vkAcquireFullScreenExclusiveModeEXT                      ) vkGetInstanceProcAddr( instance, "vkAcquireFullScreenExclusiveModeEXT" );
                vkReleaseFullScreenExclusiveModeEXT                      = cast( PFN_vkReleaseFullScreenExclusiveModeEXT                      ) vkGetInstanceProcAddr( instance, "vkReleaseFullScreenExclusiveModeEXT" );
                vkGetDeviceGroupSurfacePresentModes2EXT                  = cast( PFN_vkGetDeviceGroupSurfacePresentModes2EXT                  ) vkGetInstanceProcAddr( instance, "vkGetDeviceGroupSurfacePresentModes2EXT" );
            }

            // VK_EXT_metal_objects : load instance based device level function definitions
            else static if( __traits( isSame, extension, EXT_metal_objects )) {
                vkExportMetalObjectsEXT                                  = cast( PFN_vkExportMetalObjectsEXT                                  ) vkGetInstanceProcAddr( instance, "vkExportMetalObjectsEXT" );
            }

            // VK_FUCHSIA_external_memory : load instance based device level function definitions
            else static if( __traits( isSame, extension, FUCHSIA_external_memory )) {
                vkGetMemoryZirconHandleFUCHSIA                           = cast( PFN_vkGetMemoryZirconHandleFUCHSIA                           ) vkGetInstanceProcAddr( instance, "vkGetMemoryZirconHandleFUCHSIA" );
                vkGetMemoryZirconHandlePropertiesFUCHSIA                 = cast( PFN_vkGetMemoryZirconHandlePropertiesFUCHSIA                 ) vkGetInstanceProcAddr( instance, "vkGetMemoryZirconHandlePropertiesFUCHSIA" );
            }

            // VK_FUCHSIA_external_semaphore : load instance based device level function definitions
            else static if( __traits( isSame, extension, FUCHSIA_external_semaphore )) {
                vkImportSemaphoreZirconHandleFUCHSIA                     = cast( PFN_vkImportSemaphoreZirconHandleFUCHSIA                     ) vkGetInstanceProcAddr( instance, "vkImportSemaphoreZirconHandleFUCHSIA" );
                vkGetSemaphoreZirconHandleFUCHSIA                        = cast( PFN_vkGetSemaphoreZirconHandleFUCHSIA                        ) vkGetInstanceProcAddr( instance, "vkGetSemaphoreZirconHandleFUCHSIA" );
            }

            // VK_FUCHSIA_buffer_collection : load instance based device level function definitions
            else static if( __traits( isSame, extension, FUCHSIA_buffer_collection )) {
                vkCreateBufferCollectionFUCHSIA                          = cast( PFN_vkCreateBufferCollectionFUCHSIA                          ) vkGetInstanceProcAddr( instance, "vkCreateBufferCollectionFUCHSIA" );
                vkSetBufferCollectionImageConstraintsFUCHSIA             = cast( PFN_vkSetBufferCollectionImageConstraintsFUCHSIA             ) vkGetInstanceProcAddr( instance, "vkSetBufferCollectionImageConstraintsFUCHSIA" );
                vkSetBufferCollectionBufferConstraintsFUCHSIA            = cast( PFN_vkSetBufferCollectionBufferConstraintsFUCHSIA            ) vkGetInstanceProcAddr( instance, "vkSetBufferCollectionBufferConstraintsFUCHSIA" );
                vkDestroyBufferCollectionFUCHSIA                         = cast( PFN_vkDestroyBufferCollectionFUCHSIA                         ) vkGetInstanceProcAddr( instance, "vkDestroyBufferCollectionFUCHSIA" );
                vkGetBufferCollectionPropertiesFUCHSIA                   = cast( PFN_vkGetBufferCollectionPropertiesFUCHSIA                   ) vkGetInstanceProcAddr( instance, "vkGetBufferCollectionPropertiesFUCHSIA" );
            }
        }
    }

    // compose device based loadDeviceLevelFunctionsExtD function out of unextended
    // loadDeviceLevelFunctions and additional function pointers from extensions
    // suffix D is required as, we cannot mixin mixin two overloads with the same symbol name (any more!)
    void loadDeviceLevelFunctionsExtD( VkDevice device ) {

        // first load all non platform related function pointers from implementation
        erupted.functions.loadDeviceLevelFunctions( device );

        // 4. loop through alias sequence and mixin corresponding
        // device based device level function pointer definitions
        static foreach( extension; noDuplicateExtensions ) {

            // VK_KHR_external_memory_win32 : load device based device level function definitions
            static if( __traits( isSame, extension, KHR_external_memory_win32 )) {
                vkGetMemoryWin32HandleKHR                                = cast( PFN_vkGetMemoryWin32HandleKHR                                ) vkGetDeviceProcAddr( device, "vkGetMemoryWin32HandleKHR" );
                vkGetMemoryWin32HandlePropertiesKHR                      = cast( PFN_vkGetMemoryWin32HandlePropertiesKHR                      ) vkGetDeviceProcAddr( device, "vkGetMemoryWin32HandlePropertiesKHR" );
            }

            // VK_KHR_external_semaphore_win32 : load device based device level function definitions
            else static if( __traits( isSame, extension, KHR_external_semaphore_win32 )) {
                vkImportSemaphoreWin32HandleKHR                          = cast( PFN_vkImportSemaphoreWin32HandleKHR                          ) vkGetDeviceProcAddr( device, "vkImportSemaphoreWin32HandleKHR" );
                vkGetSemaphoreWin32HandleKHR                             = cast( PFN_vkGetSemaphoreWin32HandleKHR                             ) vkGetDeviceProcAddr( device, "vkGetSemaphoreWin32HandleKHR" );
            }

            // VK_KHR_external_fence_win32 : load device based device level function definitions
            else static if( __traits( isSame, extension, KHR_external_fence_win32 )) {
                vkImportFenceWin32HandleKHR                              = cast( PFN_vkImportFenceWin32HandleKHR                              ) vkGetDeviceProcAddr( device, "vkImportFenceWin32HandleKHR" );
                vkGetFenceWin32HandleKHR                                 = cast( PFN_vkGetFenceWin32HandleKHR                                 ) vkGetDeviceProcAddr( device, "vkGetFenceWin32HandleKHR" );
            }

            // VK_KHR_video_encode_queue : load device based device level function definitions
            else static if( __traits( isSame, extension, KHR_video_encode_queue )) {
                vkCmdEncodeVideoKHR                                      = cast( PFN_vkCmdEncodeVideoKHR                                      ) vkGetDeviceProcAddr( device, "vkCmdEncodeVideoKHR" );
            }

            // VK_NV_external_memory_win32 : load device based device level function definitions
            else static if( __traits( isSame, extension, NV_external_memory_win32 )) {
                vkGetMemoryWin32HandleNV                                 = cast( PFN_vkGetMemoryWin32HandleNV                                 ) vkGetDeviceProcAddr( device, "vkGetMemoryWin32HandleNV" );
            }

            // VK_ANDROID_external_memory_android_hardware_buffer : load device based device level function definitions
            else static if( __traits( isSame, extension, ANDROID_external_memory_android_hardware_buffer )) {
                vkGetAndroidHardwareBufferPropertiesANDROID              = cast( PFN_vkGetAndroidHardwareBufferPropertiesANDROID              ) vkGetDeviceProcAddr( device, "vkGetAndroidHardwareBufferPropertiesANDROID" );
                vkGetMemoryAndroidHardwareBufferANDROID                  = cast( PFN_vkGetMemoryAndroidHardwareBufferANDROID                  ) vkGetDeviceProcAddr( device, "vkGetMemoryAndroidHardwareBufferANDROID" );
            }

            // VK_EXT_full_screen_exclusive : load device based device level function definitions
            else static if( __traits( isSame, extension, EXT_full_screen_exclusive )) {
                vkAcquireFullScreenExclusiveModeEXT                      = cast( PFN_vkAcquireFullScreenExclusiveModeEXT                      ) vkGetDeviceProcAddr( device, "vkAcquireFullScreenExclusiveModeEXT" );
                vkReleaseFullScreenExclusiveModeEXT                      = cast( PFN_vkReleaseFullScreenExclusiveModeEXT                      ) vkGetDeviceProcAddr( device, "vkReleaseFullScreenExclusiveModeEXT" );
                vkGetDeviceGroupSurfacePresentModes2EXT                  = cast( PFN_vkGetDeviceGroupSurfacePresentModes2EXT                  ) vkGetDeviceProcAddr( device, "vkGetDeviceGroupSurfacePresentModes2EXT" );
            }

            // VK_EXT_metal_objects : load device based device level function definitions
            else static if( __traits( isSame, extension, EXT_metal_objects )) {
                vkExportMetalObjectsEXT                                  = cast( PFN_vkExportMetalObjectsEXT                                  ) vkGetDeviceProcAddr( device, "vkExportMetalObjectsEXT" );
            }

            // VK_FUCHSIA_external_memory : load device based device level function definitions
            else static if( __traits( isSame, extension, FUCHSIA_external_memory )) {
                vkGetMemoryZirconHandleFUCHSIA                           = cast( PFN_vkGetMemoryZirconHandleFUCHSIA                           ) vkGetDeviceProcAddr( device, "vkGetMemoryZirconHandleFUCHSIA" );
                vkGetMemoryZirconHandlePropertiesFUCHSIA                 = cast( PFN_vkGetMemoryZirconHandlePropertiesFUCHSIA                 ) vkGetDeviceProcAddr( device, "vkGetMemoryZirconHandlePropertiesFUCHSIA" );
            }

            // VK_FUCHSIA_external_semaphore : load device based device level function definitions
            else static if( __traits( isSame, extension, FUCHSIA_external_semaphore )) {
                vkImportSemaphoreZirconHandleFUCHSIA                     = cast( PFN_vkImportSemaphoreZirconHandleFUCHSIA                     ) vkGetDeviceProcAddr( device, "vkImportSemaphoreZirconHandleFUCHSIA" );
                vkGetSemaphoreZirconHandleFUCHSIA                        = cast( PFN_vkGetSemaphoreZirconHandleFUCHSIA                        ) vkGetDeviceProcAddr( device, "vkGetSemaphoreZirconHandleFUCHSIA" );
            }

            // VK_FUCHSIA_buffer_collection : load device based device level function definitions
            else static if( __traits( isSame, extension, FUCHSIA_buffer_collection )) {
                vkCreateBufferCollectionFUCHSIA                          = cast( PFN_vkCreateBufferCollectionFUCHSIA                          ) vkGetDeviceProcAddr( device, "vkCreateBufferCollectionFUCHSIA" );
                vkSetBufferCollectionImageConstraintsFUCHSIA             = cast( PFN_vkSetBufferCollectionImageConstraintsFUCHSIA             ) vkGetDeviceProcAddr( device, "vkSetBufferCollectionImageConstraintsFUCHSIA" );
                vkSetBufferCollectionBufferConstraintsFUCHSIA            = cast( PFN_vkSetBufferCollectionBufferConstraintsFUCHSIA            ) vkGetDeviceProcAddr( device, "vkSetBufferCollectionBufferConstraintsFUCHSIA" );
                vkDestroyBufferCollectionFUCHSIA                         = cast( PFN_vkDestroyBufferCollectionFUCHSIA                         ) vkGetDeviceProcAddr( device, "vkDestroyBufferCollectionFUCHSIA" );
                vkGetBufferCollectionPropertiesFUCHSIA                   = cast( PFN_vkGetBufferCollectionPropertiesFUCHSIA                   ) vkGetDeviceProcAddr( device, "vkGetBufferCollectionPropertiesFUCHSIA" );
            }
        }
    }

    // compose extended dispatch device out of unextended original dispatch device with
    // extended, device based loadDeviceLevelFunctionsExt member function,
    // device and command buffer based function pointer decelerations
    struct DispatchDeviceExt {

        // use unextended dispatch device from module erupted.functions as member and alias this
        erupted.dispatch_device.DispatchDevice commonDispatchDevice;
        alias commonDispatchDevice this;

        // Constructor forwards parameter 'device' to 'loadDeviceLevelFunctionsExt'
        this( VkDevice device ) {
            loadDeviceLevelFunctionsExt( device );
        }

        // backwards compatibility alias
        alias loadDeviceLevelFunctions = loadDeviceLevelFunctionsExt;

        // compose device based loadDeviceLevelFunctionsExt member function out of unextended
        // loadDeviceLevelFunctions and additional member function pointers from extensions
        void loadDeviceLevelFunctionsExt( VkDevice device ) {

            // first load all non platform related member function pointers of wrapped commonDispatchDevice
            commonDispatchDevice.loadDeviceLevelFunctions( device );

            // 5. loop through alias sequence and mixin corresponding
            // device level member function pointer definitions of this wrapping DispatchDevice
            static foreach( extension; noDuplicateExtensions ) {

                // VK_KHR_external_memory_win32 : load dispatch device member function definitions
                static if( __traits( isSame, extension, KHR_external_memory_win32 )) {
                    vkGetMemoryWin32HandleKHR                                = cast( PFN_vkGetMemoryWin32HandleKHR                                ) vkGetDeviceProcAddr( device, "vkGetMemoryWin32HandleKHR" );
                    vkGetMemoryWin32HandlePropertiesKHR                      = cast( PFN_vkGetMemoryWin32HandlePropertiesKHR                      ) vkGetDeviceProcAddr( device, "vkGetMemoryWin32HandlePropertiesKHR" );
                }

                // VK_KHR_external_semaphore_win32 : load dispatch device member function definitions
                else static if( __traits( isSame, extension, KHR_external_semaphore_win32 )) {
                    vkImportSemaphoreWin32HandleKHR                          = cast( PFN_vkImportSemaphoreWin32HandleKHR                          ) vkGetDeviceProcAddr( device, "vkImportSemaphoreWin32HandleKHR" );
                    vkGetSemaphoreWin32HandleKHR                             = cast( PFN_vkGetSemaphoreWin32HandleKHR                             ) vkGetDeviceProcAddr( device, "vkGetSemaphoreWin32HandleKHR" );
                }

                // VK_KHR_external_fence_win32 : load dispatch device member function definitions
                else static if( __traits( isSame, extension, KHR_external_fence_win32 )) {
                    vkImportFenceWin32HandleKHR                              = cast( PFN_vkImportFenceWin32HandleKHR                              ) vkGetDeviceProcAddr( device, "vkImportFenceWin32HandleKHR" );
                    vkGetFenceWin32HandleKHR                                 = cast( PFN_vkGetFenceWin32HandleKHR                                 ) vkGetDeviceProcAddr( device, "vkGetFenceWin32HandleKHR" );
                }

                // VK_KHR_video_encode_queue : load dispatch device member function definitions
                else static if( __traits( isSame, extension, KHR_video_encode_queue )) {
                    vkCmdEncodeVideoKHR                                      = cast( PFN_vkCmdEncodeVideoKHR                                      ) vkGetDeviceProcAddr( device, "vkCmdEncodeVideoKHR" );
                }

                // VK_NV_external_memory_win32 : load dispatch device member function definitions
                else static if( __traits( isSame, extension, NV_external_memory_win32 )) {
                    vkGetMemoryWin32HandleNV                                 = cast( PFN_vkGetMemoryWin32HandleNV                                 ) vkGetDeviceProcAddr( device, "vkGetMemoryWin32HandleNV" );
                }

                // VK_ANDROID_external_memory_android_hardware_buffer : load dispatch device member function definitions
                else static if( __traits( isSame, extension, ANDROID_external_memory_android_hardware_buffer )) {
                    vkGetAndroidHardwareBufferPropertiesANDROID              = cast( PFN_vkGetAndroidHardwareBufferPropertiesANDROID              ) vkGetDeviceProcAddr( device, "vkGetAndroidHardwareBufferPropertiesANDROID" );
                    vkGetMemoryAndroidHardwareBufferANDROID                  = cast( PFN_vkGetMemoryAndroidHardwareBufferANDROID                  ) vkGetDeviceProcAddr( device, "vkGetMemoryAndroidHardwareBufferANDROID" );
                }

                // VK_EXT_full_screen_exclusive : load dispatch device member function definitions
                else static if( __traits( isSame, extension, EXT_full_screen_exclusive )) {
                    vkAcquireFullScreenExclusiveModeEXT                      = cast( PFN_vkAcquireFullScreenExclusiveModeEXT                      ) vkGetDeviceProcAddr( device, "vkAcquireFullScreenExclusiveModeEXT" );
                    vkReleaseFullScreenExclusiveModeEXT                      = cast( PFN_vkReleaseFullScreenExclusiveModeEXT                      ) vkGetDeviceProcAddr( device, "vkReleaseFullScreenExclusiveModeEXT" );
                    vkGetDeviceGroupSurfacePresentModes2EXT                  = cast( PFN_vkGetDeviceGroupSurfacePresentModes2EXT                  ) vkGetDeviceProcAddr( device, "vkGetDeviceGroupSurfacePresentModes2EXT" );
                }

                // VK_EXT_metal_objects : load dispatch device member function definitions
                else static if( __traits( isSame, extension, EXT_metal_objects )) {
                    vkExportMetalObjectsEXT                                  = cast( PFN_vkExportMetalObjectsEXT                                  ) vkGetDeviceProcAddr( device, "vkExportMetalObjectsEXT" );
                }

                // VK_FUCHSIA_external_memory : load dispatch device member function definitions
                else static if( __traits( isSame, extension, FUCHSIA_external_memory )) {
                    vkGetMemoryZirconHandleFUCHSIA                           = cast( PFN_vkGetMemoryZirconHandleFUCHSIA                           ) vkGetDeviceProcAddr( device, "vkGetMemoryZirconHandleFUCHSIA" );
                    vkGetMemoryZirconHandlePropertiesFUCHSIA                 = cast( PFN_vkGetMemoryZirconHandlePropertiesFUCHSIA                 ) vkGetDeviceProcAddr( device, "vkGetMemoryZirconHandlePropertiesFUCHSIA" );
                }

                // VK_FUCHSIA_external_semaphore : load dispatch device member function definitions
                else static if( __traits( isSame, extension, FUCHSIA_external_semaphore )) {
                    vkImportSemaphoreZirconHandleFUCHSIA                     = cast( PFN_vkImportSemaphoreZirconHandleFUCHSIA                     ) vkGetDeviceProcAddr( device, "vkImportSemaphoreZirconHandleFUCHSIA" );
                    vkGetSemaphoreZirconHandleFUCHSIA                        = cast( PFN_vkGetSemaphoreZirconHandleFUCHSIA                        ) vkGetDeviceProcAddr( device, "vkGetSemaphoreZirconHandleFUCHSIA" );
                }

                // VK_FUCHSIA_buffer_collection : load dispatch device member function definitions
                else static if( __traits( isSame, extension, FUCHSIA_buffer_collection )) {
                    vkCreateBufferCollectionFUCHSIA                          = cast( PFN_vkCreateBufferCollectionFUCHSIA                          ) vkGetDeviceProcAddr( device, "vkCreateBufferCollectionFUCHSIA" );
                    vkSetBufferCollectionImageConstraintsFUCHSIA             = cast( PFN_vkSetBufferCollectionImageConstraintsFUCHSIA             ) vkGetDeviceProcAddr( device, "vkSetBufferCollectionImageConstraintsFUCHSIA" );
                    vkSetBufferCollectionBufferConstraintsFUCHSIA            = cast( PFN_vkSetBufferCollectionBufferConstraintsFUCHSIA            ) vkGetDeviceProcAddr( device, "vkSetBufferCollectionBufferConstraintsFUCHSIA" );
                    vkDestroyBufferCollectionFUCHSIA                         = cast( PFN_vkDestroyBufferCollectionFUCHSIA                         ) vkGetDeviceProcAddr( device, "vkDestroyBufferCollectionFUCHSIA" );
                    vkGetBufferCollectionPropertiesFUCHSIA                   = cast( PFN_vkGetBufferCollectionPropertiesFUCHSIA                   ) vkGetDeviceProcAddr( device, "vkGetBufferCollectionPropertiesFUCHSIA" );
                }
            }
        }

        // 6. loop through alias sequence and mixin corresponding convenience member functions
        // omitting device parameter of this wrapping DispatchDevice. Member vkDevice of commonDispatchDevice is used instead
        static foreach( extension; noDuplicateExtensions ) {

            // VK_KHR_external_memory_win32 : dispatch device convenience member functions
            static if( __traits( isSame, extension, KHR_external_memory_win32 )) {
                VkResult  GetMemoryWin32HandleKHR( const( VkMemoryGetWin32HandleInfoKHR )* pGetWin32HandleInfo, HANDLE* pHandle ) { return vkGetMemoryWin32HandleKHR( vkDevice, pGetWin32HandleInfo, pHandle ); }
                VkResult  GetMemoryWin32HandlePropertiesKHR( VkExternalMemoryHandleTypeFlagBits handleType, HANDLE handle, VkMemoryWin32HandlePropertiesKHR* pMemoryWin32HandleProperties ) { return vkGetMemoryWin32HandlePropertiesKHR( vkDevice, handleType, handle, pMemoryWin32HandleProperties ); }
            }

            // VK_KHR_external_semaphore_win32 : dispatch device convenience member functions
            else static if( __traits( isSame, extension, KHR_external_semaphore_win32 )) {
                VkResult  ImportSemaphoreWin32HandleKHR( const( VkImportSemaphoreWin32HandleInfoKHR )* pImportSemaphoreWin32HandleInfo ) { return vkImportSemaphoreWin32HandleKHR( vkDevice, pImportSemaphoreWin32HandleInfo ); }
                VkResult  GetSemaphoreWin32HandleKHR( const( VkSemaphoreGetWin32HandleInfoKHR )* pGetWin32HandleInfo, HANDLE* pHandle ) { return vkGetSemaphoreWin32HandleKHR( vkDevice, pGetWin32HandleInfo, pHandle ); }
            }

            // VK_KHR_external_fence_win32 : dispatch device convenience member functions
            else static if( __traits( isSame, extension, KHR_external_fence_win32 )) {
                VkResult  ImportFenceWin32HandleKHR( const( VkImportFenceWin32HandleInfoKHR )* pImportFenceWin32HandleInfo ) { return vkImportFenceWin32HandleKHR( vkDevice, pImportFenceWin32HandleInfo ); }
                VkResult  GetFenceWin32HandleKHR( const( VkFenceGetWin32HandleInfoKHR )* pGetWin32HandleInfo, HANDLE* pHandle ) { return vkGetFenceWin32HandleKHR( vkDevice, pGetWin32HandleInfo, pHandle ); }
            }

            // VK_KHR_video_encode_queue : dispatch device convenience member functions
            else static if( __traits( isSame, extension, KHR_video_encode_queue )) {
                void      CmdEncodeVideoKHR( const( VkVideoEncodeInfoKHR )* pEncodeInfo ) { vkCmdEncodeVideoKHR( commandBuffer, pEncodeInfo ); }
            }

            // VK_NV_external_memory_win32 : dispatch device convenience member functions
            else static if( __traits( isSame, extension, NV_external_memory_win32 )) {
                VkResult  GetMemoryWin32HandleNV( VkDeviceMemory memory, VkExternalMemoryHandleTypeFlagsNV handleType, HANDLE* pHandle ) { return vkGetMemoryWin32HandleNV( vkDevice, memory, handleType, pHandle ); }
            }

            // VK_ANDROID_external_memory_android_hardware_buffer : dispatch device convenience member functions
            else static if( __traits( isSame, extension, ANDROID_external_memory_android_hardware_buffer )) {
                VkResult  GetAndroidHardwareBufferPropertiesANDROID( const( AHardwareBuffer )* buffer, VkAndroidHardwareBufferPropertiesANDROID* pProperties ) { return vkGetAndroidHardwareBufferPropertiesANDROID( vkDevice, buffer, pProperties ); }
                VkResult  GetMemoryAndroidHardwareBufferANDROID( const( VkMemoryGetAndroidHardwareBufferInfoANDROID )* pInfo, AHardwareBuffer pBuffer ) { return vkGetMemoryAndroidHardwareBufferANDROID( vkDevice, pInfo, pBuffer ); }
            }

            // VK_EXT_full_screen_exclusive : dispatch device convenience member functions
            else static if( __traits( isSame, extension, EXT_full_screen_exclusive )) {
                VkResult  AcquireFullScreenExclusiveModeEXT( VkSwapchainKHR swapchain ) { return vkAcquireFullScreenExclusiveModeEXT( vkDevice, swapchain ); }
                VkResult  ReleaseFullScreenExclusiveModeEXT( VkSwapchainKHR swapchain ) { return vkReleaseFullScreenExclusiveModeEXT( vkDevice, swapchain ); }
                VkResult  GetDeviceGroupSurfacePresentModes2EXT( const( VkPhysicalDeviceSurfaceInfo2KHR )* pSurfaceInfo, VkDeviceGroupPresentModeFlagsKHR* pModes ) { return vkGetDeviceGroupSurfacePresentModes2EXT( vkDevice, pSurfaceInfo, pModes ); }
            }

            // VK_EXT_metal_objects : dispatch device convenience member functions
            else static if( __traits( isSame, extension, EXT_metal_objects )) {
                void      ExportMetalObjectsEXT( VkExportMetalObjectsInfoEXT* pMetalObjectsInfo ) { vkExportMetalObjectsEXT( vkDevice, pMetalObjectsInfo ); }
            }

            // VK_FUCHSIA_external_memory : dispatch device convenience member functions
            else static if( __traits( isSame, extension, FUCHSIA_external_memory )) {
                VkResult  GetMemoryZirconHandleFUCHSIA( const( VkMemoryGetZirconHandleInfoFUCHSIA )* pGetZirconHandleInfo, zx_handle_t* pZirconHandle ) { return vkGetMemoryZirconHandleFUCHSIA( vkDevice, pGetZirconHandleInfo, pZirconHandle ); }
                VkResult  GetMemoryZirconHandlePropertiesFUCHSIA( VkExternalMemoryHandleTypeFlagBits handleType, zx_handle_t zirconHandle, VkMemoryZirconHandlePropertiesFUCHSIA* pMemoryZirconHandleProperties ) { return vkGetMemoryZirconHandlePropertiesFUCHSIA( vkDevice, handleType, zirconHandle, pMemoryZirconHandleProperties ); }
            }

            // VK_FUCHSIA_external_semaphore : dispatch device convenience member functions
            else static if( __traits( isSame, extension, FUCHSIA_external_semaphore )) {
                VkResult  ImportSemaphoreZirconHandleFUCHSIA( const( VkImportSemaphoreZirconHandleInfoFUCHSIA )* pImportSemaphoreZirconHandleInfo ) { return vkImportSemaphoreZirconHandleFUCHSIA( vkDevice, pImportSemaphoreZirconHandleInfo ); }
                VkResult  GetSemaphoreZirconHandleFUCHSIA( const( VkSemaphoreGetZirconHandleInfoFUCHSIA )* pGetZirconHandleInfo, zx_handle_t* pZirconHandle ) { return vkGetSemaphoreZirconHandleFUCHSIA( vkDevice, pGetZirconHandleInfo, pZirconHandle ); }
            }

            // VK_FUCHSIA_buffer_collection : dispatch device convenience member functions
            else static if( __traits( isSame, extension, FUCHSIA_buffer_collection )) {
                VkResult  CreateBufferCollectionFUCHSIA( const( VkBufferCollectionCreateInfoFUCHSIA )* pCreateInfo, VkBufferCollectionFUCHSIA* pCollection ) { return vkCreateBufferCollectionFUCHSIA( vkDevice, pCreateInfo, pAllocator, pCollection ); }
                VkResult  SetBufferCollectionImageConstraintsFUCHSIA( VkBufferCollectionFUCHSIA collection, const( VkImageConstraintsInfoFUCHSIA )* pImageConstraintsInfo ) { return vkSetBufferCollectionImageConstraintsFUCHSIA( vkDevice, collection, pImageConstraintsInfo ); }
                VkResult  SetBufferCollectionBufferConstraintsFUCHSIA( VkBufferCollectionFUCHSIA collection, const( VkBufferConstraintsInfoFUCHSIA )* pBufferConstraintsInfo ) { return vkSetBufferCollectionBufferConstraintsFUCHSIA( vkDevice, collection, pBufferConstraintsInfo ); }
                void      DestroyBufferCollectionFUCHSIA( VkBufferCollectionFUCHSIA collection ) { vkDestroyBufferCollectionFUCHSIA( vkDevice, collection, pAllocator ); }
                VkResult  GetBufferCollectionPropertiesFUCHSIA( VkBufferCollectionFUCHSIA collection, VkBufferCollectionPropertiesFUCHSIA* pProperties ) { return vkGetBufferCollectionPropertiesFUCHSIA( vkDevice, collection, pProperties ); }
            }
        }

        // 7. loop last time through alias sequence and mixin corresponding function pointer declarations
        static foreach( extension; noDuplicateExtensions ) {

            // VK_KHR_xlib_surface : dispatch device member function pointer decelerations
            static if( __traits( isSame, extension, KHR_xlib_surface )) {
                PFN_vkCreateXlibSurfaceKHR                                            vkCreateXlibSurfaceKHR;
                PFN_vkGetPhysicalDeviceXlibPresentationSupportKHR                     vkGetPhysicalDeviceXlibPresentationSupportKHR;
            }

            // VK_KHR_xcb_surface : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, KHR_xcb_surface )) {
                PFN_vkCreateXcbSurfaceKHR                                             vkCreateXcbSurfaceKHR;
                PFN_vkGetPhysicalDeviceXcbPresentationSupportKHR                      vkGetPhysicalDeviceXcbPresentationSupportKHR;
            }

            // VK_KHR_wayland_surface : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, KHR_wayland_surface )) {
                PFN_vkCreateWaylandSurfaceKHR                                         vkCreateWaylandSurfaceKHR;
                PFN_vkGetPhysicalDeviceWaylandPresentationSupportKHR                  vkGetPhysicalDeviceWaylandPresentationSupportKHR;
            }

            // VK_KHR_android_surface : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, KHR_android_surface )) {
                PFN_vkCreateAndroidSurfaceKHR                                         vkCreateAndroidSurfaceKHR;
            }

            // VK_KHR_win32_surface : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, KHR_win32_surface )) {
                PFN_vkCreateWin32SurfaceKHR                                           vkCreateWin32SurfaceKHR;
                PFN_vkGetPhysicalDeviceWin32PresentationSupportKHR                    vkGetPhysicalDeviceWin32PresentationSupportKHR;
            }

            // VK_KHR_external_memory_win32 : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, KHR_external_memory_win32 )) {
                PFN_vkGetMemoryWin32HandleKHR                                         vkGetMemoryWin32HandleKHR;
                PFN_vkGetMemoryWin32HandlePropertiesKHR                               vkGetMemoryWin32HandlePropertiesKHR;
            }

            // VK_KHR_external_semaphore_win32 : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, KHR_external_semaphore_win32 )) {
                PFN_vkImportSemaphoreWin32HandleKHR                                   vkImportSemaphoreWin32HandleKHR;
                PFN_vkGetSemaphoreWin32HandleKHR                                      vkGetSemaphoreWin32HandleKHR;
            }

            // VK_KHR_external_fence_win32 : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, KHR_external_fence_win32 )) {
                PFN_vkImportFenceWin32HandleKHR                                       vkImportFenceWin32HandleKHR;
                PFN_vkGetFenceWin32HandleKHR                                          vkGetFenceWin32HandleKHR;
            }

            // VK_KHR_video_encode_queue : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, KHR_video_encode_queue )) {
                PFN_vkCmdEncodeVideoKHR                                               vkCmdEncodeVideoKHR;
            }

            // VK_GGP_stream_descriptor_surface : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, GGP_stream_descriptor_surface )) {
                PFN_vkCreateStreamDescriptorSurfaceGGP                                vkCreateStreamDescriptorSurfaceGGP;
            }

            // VK_NV_external_memory_win32 : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, NV_external_memory_win32 )) {
                PFN_vkGetMemoryWin32HandleNV                                          vkGetMemoryWin32HandleNV;
            }

            // VK_NN_vi_surface : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, NN_vi_surface )) {
                PFN_vkCreateViSurfaceNN                                               vkCreateViSurfaceNN;
            }

            // VK_EXT_acquire_xlib_display : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, EXT_acquire_xlib_display )) {
                PFN_vkAcquireXlibDisplayEXT                                           vkAcquireXlibDisplayEXT;
                PFN_vkGetRandROutputDisplayEXT                                        vkGetRandROutputDisplayEXT;
            }

            // VK_MVK_ios_surface : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, MVK_ios_surface )) {
                PFN_vkCreateIOSSurfaceMVK                                             vkCreateIOSSurfaceMVK;
            }

            // VK_MVK_macos_surface : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, MVK_macos_surface )) {
                PFN_vkCreateMacOSSurfaceMVK                                           vkCreateMacOSSurfaceMVK;
            }

            // VK_ANDROID_external_memory_android_hardware_buffer : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, ANDROID_external_memory_android_hardware_buffer )) {
                PFN_vkGetAndroidHardwareBufferPropertiesANDROID                       vkGetAndroidHardwareBufferPropertiesANDROID;
                PFN_vkGetMemoryAndroidHardwareBufferANDROID                           vkGetMemoryAndroidHardwareBufferANDROID;
            }

            // VK_FUCHSIA_imagepipe_surface : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, FUCHSIA_imagepipe_surface )) {
                PFN_vkCreateImagePipeSurfaceFUCHSIA                                   vkCreateImagePipeSurfaceFUCHSIA;
            }

            // VK_EXT_metal_surface : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, EXT_metal_surface )) {
                PFN_vkCreateMetalSurfaceEXT                                           vkCreateMetalSurfaceEXT;
            }

            // VK_EXT_full_screen_exclusive : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, EXT_full_screen_exclusive )) {
                PFN_vkGetPhysicalDeviceSurfacePresentModes2EXT                        vkGetPhysicalDeviceSurfacePresentModes2EXT;
                PFN_vkAcquireFullScreenExclusiveModeEXT                               vkAcquireFullScreenExclusiveModeEXT;
                PFN_vkReleaseFullScreenExclusiveModeEXT                               vkReleaseFullScreenExclusiveModeEXT;
                PFN_vkGetDeviceGroupSurfacePresentModes2EXT                           vkGetDeviceGroupSurfacePresentModes2EXT;
            }

            // VK_EXT_metal_objects : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, EXT_metal_objects )) {
                PFN_vkExportMetalObjectsEXT                                           vkExportMetalObjectsEXT;
            }

            // VK_NV_acquire_winrt_display : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, NV_acquire_winrt_display )) {
                PFN_vkAcquireWinrtDisplayNV                                           vkAcquireWinrtDisplayNV;
                PFN_vkGetWinrtDisplayNV                                               vkGetWinrtDisplayNV;
            }

            // VK_EXT_directfb_surface : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, EXT_directfb_surface )) {
                PFN_vkCreateDirectFBSurfaceEXT                                        vkCreateDirectFBSurfaceEXT;
                PFN_vkGetPhysicalDeviceDirectFBPresentationSupportEXT                 vkGetPhysicalDeviceDirectFBPresentationSupportEXT;
            }

            // VK_FUCHSIA_external_memory : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, FUCHSIA_external_memory )) {
                PFN_vkGetMemoryZirconHandleFUCHSIA                                    vkGetMemoryZirconHandleFUCHSIA;
                PFN_vkGetMemoryZirconHandlePropertiesFUCHSIA                          vkGetMemoryZirconHandlePropertiesFUCHSIA;
            }

            // VK_FUCHSIA_external_semaphore : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, FUCHSIA_external_semaphore )) {
                PFN_vkImportSemaphoreZirconHandleFUCHSIA                              vkImportSemaphoreZirconHandleFUCHSIA;
                PFN_vkGetSemaphoreZirconHandleFUCHSIA                                 vkGetSemaphoreZirconHandleFUCHSIA;
            }

            // VK_FUCHSIA_buffer_collection : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, FUCHSIA_buffer_collection )) {
                PFN_vkCreateBufferCollectionFUCHSIA                                   vkCreateBufferCollectionFUCHSIA;
                PFN_vkSetBufferCollectionImageConstraintsFUCHSIA                      vkSetBufferCollectionImageConstraintsFUCHSIA;
                PFN_vkSetBufferCollectionBufferConstraintsFUCHSIA                     vkSetBufferCollectionBufferConstraintsFUCHSIA;
                PFN_vkDestroyBufferCollectionFUCHSIA                                  vkDestroyBufferCollectionFUCHSIA;
                PFN_vkGetBufferCollectionPropertiesFUCHSIA                            vkGetBufferCollectionPropertiesFUCHSIA;
            }

            // VK_QNX_screen_surface : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, QNX_screen_surface )) {
                PFN_vkCreateScreenSurfaceQNX                                          vkCreateScreenSurfaceQNX;
                PFN_vkGetPhysicalDeviceScreenPresentationSupportQNX                   vkGetPhysicalDeviceScreenPresentationSupportQNX;
            }
        }
    }
}
