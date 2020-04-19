mtype = {locked, unlocked, freed};
mtype mtx = unlocked; 

// bool lock_freed_mtx = false;
// bool unlock_mtx_twice = false;
// bool unlock_freed_mtx = false;  
// bool destroy_locked_mtx = false;
// bool obvious_mistake = true;
// TODO: typedef fridge_thr 
// More granularity 


inline PTHREAD_MUTEX_lock(mtx) {
    atomic{
        mtx == unlocked; mtx = locked;
    }    
}

inline PTHREAD_MUTEX_unlock(mtx) { 
    atomic{
        mtx = unlocked; 
    }
    // atomic{
    //     if
    //     :: (mtx == locked) -> mtx = unlocked; 
    //     :: (mtx == unlocked) -> unlock_mtx_twice = true; 
    //     :: (mtx == freed) -> unlock_freed_mtx = true; 
    //     fi
    
}


inline PTHREAD_MUTEX_destroy(mtx) {
    atomic {mtx = freed}
    // atomic{     
    //     if 
    //     ::(mtx == locked) -> destroy_locked_mtx = true;
    //     :: else -> mtx = freed;
    //     fi
    // }
}


// TODO: simulate this part better 
active proctype fridgethr_freeze() {
    PTHREAD_MUTEX_lock(mtx);
    PTHREAD_MUTEX_unlock(mtx);
}

// active proctype fridgethr_destroy_before() {
//     PTHREAD_MUTEX_destroy(mtx);
// }


// active proctype fridgethr_destroy_after() {
//         PTHREAD_MUTEX_lock(mtx);
//         PTHREAD_MUTEX_unlock(mtx);
//         PTHREAD_MUTEX_destroy(mtx);
// }


// never{
//     do
//     :: unlock_mtx_twice -> break 
//     :: unlock_freed_mtx -> break
//     :: destroy_locked_mtx -> break
//     :: lock_freed_mtx -> break 
//     :: obvious_mistake -> break
//     :: destroy_locked_mtx -> break // THIS PART IDENTIFIES THE BUG
//     :: else 
//     od
// }

// 0 errors
// Everytime a mtx is locked it has to be eventually unlocked 
ltl locked_mutex_will_unlock {
    []((mtx == locked) -> <>(mtx == unlocked))
}


// 1 error 
// A freed mtx should never be unlocked
ltl unlock_freed_mtx {
    []((mtx == freed) -> !(<>(mtx == unlocked)))
}

// 0 errors
// A freed mtx should never be locked
ltl lock_freed_mtx {
    []((mtx == freed) -> !(<>(mtx == locked)))
}


// ltl locked_mutex_freed{
//     []((mtx == locked) -> <>(mtx == ))
// }



never  {    
// Either the mutex is at point free all the time or never free    
// define p as mutex == freed
/* !((<> ([] p)) || ([]!p)) */
T0_init:
	do
	:: ((mtx==freed)) -> goto T0_S44
	:: (1) -> goto T0_init
	od;
accept_S44:
	do
	:: (1) -> goto T0_S44
	od;
T0_S44:
	do
	:: (! ((mtx==freed))) -> goto accept_S44
	:: (1) -> goto T0_S44
	od;
}

// spin -run -ltl test something.pml


// inline PTHREAD_MUTEX_lock(mtx) {
//     atomic{
//         if 
//         :: (mtx == freed) -> lock_freed_mtx = true;
//         :: else -> mtx == unlocked; mtx = locked;
//         fi
//     }    
// }

// inline PTHREAD_MUTEX_unlock(mtx) { 
//     atomic{
//         if
//         :: (mtx == locked) -> mtx = unlocked; 
//         :: (mtx == unlocked) -> unlock_mtx_twice = true; 
//         :: (mtx == freed) -> unlock_freed_mtx = true; 
//         fi
//     }
// }

