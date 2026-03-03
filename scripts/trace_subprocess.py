#!/usr/bin/env python3
import psutil
import subprocess
import sys
import time
from typing import Set

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 trace.py <command>")
        return

    command = sys.argv[1:]
    seen_pids: Set[int] = set()

    # 启动子进程
    proc = subprocess.Popen(command)
    print(f"--- Monitoring children of PID: {proc.pid} ---")

    try:
        while proc.poll() is None:
            # 获取当前所有子进程（递归）
            try:
                parent = psutil.Process(proc.pid)
                children = parent.children(recursive=True)
                for child in children:
                    if child.pid not in seen_pids:
                        cmdline = " ".join(child.cmdline())
                        print(f"[NEW] PID {child.pid:5} | PPID {child.ppid():5} | Cmd: {cmdline}")
                        seen_pids.add(child.pid)
            except (psutil.NoSuchProcess, psutil.AccessDenied, SystemError):
                pass
            time.sleep(0.001)
    finally:
        proc.wait()
        print("--- Execution finished ---")

if __name__ == "__main__":
    main()
