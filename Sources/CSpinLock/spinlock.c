#include <sched.h>
#include <stdint.h>
#include <stdlib.h>
#include "spinlock.h"


cspinlock_t cspinlock_alloc(void) {
#ifdef __LP64__
    return malloc(sizeof(int64_t));
#else
    return malloc(sizeof(int32_t));
#endif
}

cspinlock_t cspinlock_init(cspinlock_t lock) {
    asm volatile ("" ::: "memory");
    *lock = 0;
    return lock;
}

cspinlock_t cspinlock_deinit(cspinlock_t lock) {
    return lock;
}

void cspinlock_dealloc(cspinlock_t lock) {
    free(lock);
}

void cspinlock_lock(cspinlock_t lock) {
    for (;;) {
        if (__sync_bool_compare_and_swap(lock, 0, 1))
            return;
        sched_yield();
    }
}

void cspinlock_unlock(cspinlock_t lock) {
    asm volatile ("" ::: "memory");
    *lock = 0;
}
