module commands;

import platform;

public import commands.runfile;
public import commands.addlocal;

abstract class Command
{
    this(Platform platform)
    {
        _platform = platform;
    }

    abstract void run(string[] args);

protected:
    Platform platform() { return _platform; }

private:
    Platform _platform;
}
