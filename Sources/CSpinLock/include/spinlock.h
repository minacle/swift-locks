#ifndef _SWIFT_LOCKS__C_SPIN_LOCK
#define _SWIFT_LOCKS__C_SPIN_LOCK

#include <stdint.h>


#ifdef __LP64__
typedef int64_t *cspinlock_t;
#else
typedef int32_t *cspinlock_t;
#endif

extern cspinlock_t __nonnull cspinlock_alloc(void);

extern cspinlock_t __nonnull cspinlock_init(cspinlock_t __nonnull);

extern cspinlock_t __nonnull cspinlock_deinit(cspinlock_t __nonnull);

extern void cspinlock_dealloc(cspinlock_t __nonnull);

extern void cspinlock_lock(cspinlock_t __nonnull);

extern void cspinlock_unlock(cspinlock_t __nonnull);


#endif
