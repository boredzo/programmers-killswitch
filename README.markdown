# Programmer's Killswitch

Have this running while you use Xcode. If it starts driving the system into paging hell, press ctrl-⌘-X.

Currently, the Killswitch will kill these processes:

- Xcode
- Instruments

And not yet these, but someday:

- gdb
- lldb

The kill in question is `SIGKILL`, the famous “kill -9”.

## How-to's

### How do I change the hotkey?

Change the source code.

### How do I quit the Killswitch?

Activity Monitor.
