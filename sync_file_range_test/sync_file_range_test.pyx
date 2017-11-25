
cdef extern from "fcntl.h":
     int sync_file_range(int fd, int offset, int nbytes, unsigned int flags)

def sync_file_range_test(int x):
    print("sync_file_range exists\n")
    if x==-1:
        sync_file_range(1,1,1,1)
    


