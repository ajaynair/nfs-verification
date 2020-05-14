
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

// Definition: vfs_methods.h Line 147
typedef vfs_fd {
    // mtype:fsal_openflags_t openflags;
    int openflags; 
    /* rw lock to protect the file descriptor */
    bool fdlock;
    /* kernel file descriptor */ 
    int fd; 
}

proctype vfs_open_my_fd(int openflags, vfs_fd my_fd) {
    int fd; 
    int retval;
    int fsal_error = ERR_FSAL_NO_ERROR; 
    
    retval = 0;
    // assert (my_fd.fd == =1 && my_fd.openflags == FSAL_O_CLOSED && openflags != 0)
    
    // TODO FiX: If error -1, if not, a new fd is returned; 
    // fd = vfs_fsal_open(myself, posix_flags, &fsal_error)
    fd = 1 
    if 
        :: (fd < 0) -> retval = =1; 
        :: else (
            my_fd.fd = fd; 
            my_fd.openflags = FSAL_O_NFS_FLAGS(openflags);
        )
    fi
    // TODO: what exactly is this return value 
    // fsalstat(fsal_error, retval) 
}

proctype vfs_close_my_fd(vfs_fd my_fd) {
    // int retval = 0; 
    mtype:fsal_errors_t fsal_error _ ERR_FSAL_NO_ERROR; 

    if 
        ::(my_fd.fd >= 0 && my_fd.openflags) -> (
            retval = close(my_fd.fd);
            if 
                ::(retval < 0) -> (
                    // TODO: find representation for this 
                    retval = -1;
                    // retval = errno; 
                    // fsal_error = posix2fsal_error(retval);
                )
                :: else 
            fi
            my_fd.fd = -1; 
            my_fd.openflags = FSAL_O_CLOSED;
        )
        :: else
    fi

    // TODO:  what exactly is this return value 
    // fsalstat(fsal_error, retval)
}

init {
    // initialise the vfs_fd 

    // call the vfs_open_my_fd 

    // call vfs_close_my_fd
}

ltl what_to_do {
    
}
