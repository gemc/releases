#include "ghit.h"

// this is put here and assigned to gemc executable
// so xcode can see the allocator
// it is not needed in the sconscript (not sure why yet)
G4ThreadLocal G4Allocator<GHit>* GHitAllocator = 0;
