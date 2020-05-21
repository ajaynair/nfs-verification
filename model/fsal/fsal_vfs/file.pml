
int FSAL_O_CLOSED =     0  /* Closed */
int FSAL_O_READ =       1  /* read */
int FSAL_O_WRITE =      2  /* write */
int FSAL_O_RDWR =      (FSAL_O_READ|FSAL_O_WRITE)  /* read/write: both flags
						     * explicitly or'd together
						     * so that FSAL_O_RDWR can
						     * be used as a mask */

/* Internal flags, not really NFS open flags! */
int FSAL_O_ANY =             32  /* any open file descriptor is usable */
int FSAL_O_TRUNC =           64  /* Truncate file on open */

/* DENY flags */
int FSAL_O_DENY_READ =       256
int FSAL_O_DENY_WRITE =      512
int FSAL_O_DENY_WRITE_MAND = 1024  /* Mandatory deny-write (i.e. NFSv4) */
int FSAL_O_DENY_NONE =       0

inline FSAL_O_NFS_FLAGS (flag) {
    ((flags) & 
        (FSAL_O_RDWR | FSAL_O_DENY_READ | FSAL_O_DENY_WRITE | FSAL_O_DENY_WRITE_MAND))
}

mtype:fsal_errors_t = {
    ERR_FSAL_NO_ERROR,
    ERR_FSAL_SOME_ERROR 
}

mtype:lockstate = {UNINIT, LOCKED, UNLOCKED, FREED}
mtype:lockstate obj_lock = UNINIT;
mtype:lockstate fdlock = UNINIT;

// Definition: vfs_methods.h Line 147
typedef vfs_fd {
    // mtype:fsal_openflags_t openflags;
    int openflags; 
    /* rw lock to protect the file descriptor */
    bool fdlock;
    /* kernel file descriptor */ 
    int fd; 
}

typedef fsal_obj_handle {
    bool obj_lock;
}

bool locked_twice = false;

inline PTHREAD_RWLOCK_wrLOCK() {
    if 
    :: (obj_lock==LOCKED) -> locked_twice=true;
    :: else
    fi
    obj_lock = LOCKED;
}
inline PTHERAD_RWLOCK_unlock() {
    obj_lock = UNLOCKED; 
}
inline PTHREAD_RWLOCK_init(){
    fdlock = UNLOCKED;
}
inline PTHREAD_RWLOCK_destroy(){
    fdlock = FREED;
}

proctype vfs_close(){
    PTHREAD_RWLOCK_wrLOCK();

    PTHERAD_RWLOCK_unlock();
}
// alloc_state;
proctype vfs_alloc_state() {
    PTHREAD_RWLOCK_init()
}
// free_state in export.c 
proctype vfs_free_state() {
    PTHREAD_RWLOCK_destroy()
}
proctype vfs_merge() {
    // TODO: ASK ABOUT HOW TO DEAL WITH CONDITIONALS    
    PTHREAD_RWLOCK_wrLOCK();
    PTHERAD_RWLOCK_unlock();
}
proctype vfs_reopen() {
    PTHREAD_RWLOCK_wrLOCK();
    PTHERAD_RWLOCK_unlock();
}
proctype vfs_close2(){
    PTHREAD_RWLOCK_wrLOCK();
    PTHERAD_RWLOCK_unlock();
}

active proctype call() {
    run vfs_free_state();
    run vfs_alloc_state();
}
ltl freed_not_locked_obj_lock {
    []((obj_lock==FREED) -> <>(!(obj_lock==LOCKED)));
}
ltl freed_not_locked_fdlock {
    []((fdlock==FREED) -> <>(!(fdlock==LOCKED)));
}
ltl lock_will_unlock_obj_lock {
    []((obj_lock==LOCKED) -> <>(obj_lock==UNLOCKED));
}
ltl lock_will_unlock_fdlock {
    []((fdlock==LOCKED) -> <>(fdlock==UNLOCKED));
}
ltl locked_twice_obj_lock {
    [](!locked_twice)
}


