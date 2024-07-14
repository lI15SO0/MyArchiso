# Get files sha-1 to avoid repeatedly docker image build.

import os
import hashlib
import queue
import multiprocessing
import threading

####################################################################################################

def get_fs(name):
    lst = []
    for i in os.listdir(name):
        fpath = os.path.join(name, i)
        if os.path.isfile(fpath):
            lst.append(fpath)
        else:
            lst = lst + get_fs(fpath)
    return lst

def hash_file(fname):
    sha1 = hashlib.sha1()
    with open(fname, 'rb') as f:
        sha1.update(f.read())
    return [fname, sha1.hexdigest()]

class hash_thread(threading.Thread):
    def __init__(self, in_q, out_q):
        super(hash_thread, self).__init__()
        self.in_q = in_q
        self.out_q = out_q

    def run (self):
        print("Thread running!")
        while True:
            data = self.in_q.get()
            if data == ':exit':
                break
            self.out_q.put(hash_file(data))
        
        self.out_q.put(":exit")

        print("Thread done!")
        

def hash_all_file(lst):
    result = []
    result_queue = queue.Queue()
    send_queue = queue.Queue()

    for _ in range(multiprocessing.cpu_count()):
        thread = hash_thread(send_queue, result_queue)
        thread.start()

    for i in lst:
        send_queue.put(i)

    for _ in range(multiprocessing.cpu_count()):
        send_queue.put(":exit")

    i = 0
    while i < multiprocessing.cpu_count():
        data = result_queue.get()
        if data == ':exit':
            i += 1
            continue

        result.append(data)

    return result

def write_result(result):
    with open("new.sha", "w") as f:
        for i in result:
            f.write(i[1] + " " + i[0] + '\n')

####################################################################################################

result = get_fs("fs")
result.append("./Dockerfile")
result = hash_all_file(result)
result.sort(key = lambda x: x[0])

write_result(result)
