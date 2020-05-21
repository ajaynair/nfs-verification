c_decl {
    \#include <stdbool.h>
}


c_decl{
    // Definition: vfs_methods.h Line 147
    typedef struct vfs_fd {
        // mtype:fsal_openflags_t openflags;
        int openflags; 
        /* rw lock to protect the file descriptor */
        bool fdlock;
        /* kernel file descriptor */ 
        int fd; 
    } vfs_fd; 
}

c_code {
    vfs_fd      vfs; 
    vfs_fd       *my_fd=&vfs; 
}

c_state "vfs_fd my_fd" "Global"

// proctype test(vfs_fd* my_fd){
//     my_fd.openflags =3;
// }

proctype ex2() {
    c_code {my_fd->fd = 2;}
}


init {  
    c_code {my_fd->fd = 1;}
    run ex2 () 
    c_code {printf("hi %d-----", my_fd->fd);}
}



// init{
    // vfs_fd my_fd[1];
    // my_fd[0].openflags = 0; 
    // my_fd[0].fdlock = false; 
    // my_fd[0].fdlock = 1; 
    // run test(&my_fd[0]);
    // printf("hi %d-----", my_fd[0].openflags)} 
