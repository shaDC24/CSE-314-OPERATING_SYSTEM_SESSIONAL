# 2105123_offline1_bash
# Shell Scripting Assignment - Submission Organizer
A shell script that automates the organization, analysis, and execution of student code submissions.
## Overview
This script processes student submissions downloaded from Moodle, organizing them by programming language, analyzing code metrics, and executing them against test cases.
Features

File Organization: Extracts and organizes submissions by language (C, C++, Python, Java)
Code Analysis: Counts lines, comments, and functions in submitted code
Test Execution: Compiles and runs code against provided test cases
Result Generation: Creates CSV report with student performance metrics

## Usage
bash./organize.sh <submissions> <targets> <tests> <answers> [options]
Required Arguments

submissions - Path to submission folder containing zip files
targets - Path to target directory (created if doesn't exist)
tests - Path to test case folder
answers - Path to answer folder

## Optional Flags

-v - Verbose output
-noexecute - Skip test execution
-nolc - Skip line count analysis
-nocc - Skip comment count analysis
-nofc - Skip function count analysis


## Supported Languages

C (.c) → main.c
C++ (.cpp) → main.cpp
Python (.py) → main.py
Java (.java) → Main.java

## Output
Generates result.csv with columns:

student_id, student_name, language
matched, not_matched (test results)
line_count, comment_count, function_count (code metrics)

## Requirements

bash shell
gcc (for C compilation)
g++ (for C++ compilation)
python3 (for Python execution)
javac/java (for Java compilation/execution)

# 2105123_offline2_system_call_and_scheduler

# xv6 System Call & MLFQ Scheduler Implementation

Implementation of system call tracking and multilevel feedback queue (MLFQ) scheduler for xv6 operating system.

## Overview

This project extends xv6 with:
1. **System Call History Tracking** - Monitor and collect system call statistics
2. **MLFQ Scheduler** - Two-queue scheduling with lottery and round-robin algorithms

## Features

### Task 1: System Call History
- **`history` system call** - Returns aggregated system call statistics
- **User program** - Query individual or all system call histories
- **Statistics tracked**: call count, execution time, syscall name
- **Thread-safe** with fine-grained locking

### Task 2: MLFQ Scheduler
- **Queue 1**: Lottery scheduling (probabilistic based on tickets)
- **Queue 2**: Round-robin scheduling  
- **Priority boosting** every 64 ticks
- **Ticket inheritance** for child processes
- **Process tracking** with detailed statistics

## System Calls Added

```c
int history(int syscall_num, struct syscall_stat *stat);
int settickets(int tickets);
int getpinfo(struct pstat *ps);
```

## Usage Examples

### History System Call
```bash
$ history 5          # Get history for syscall #5 (read)
5: syscall: read, #: 21, time: 58

$ history            # Get all syscall histories
1: syscall: fork, #: 6, time: 0
2: syscall: exit, #: 0, time: 0
...
```

### MLFQ Scheduler Testing
```bash
$ dummyproc 20 &     # Create process with 20 tickets
$ testprocinfo       # Display process statistics
```

## Key Implementation Details

### Scheduling Algorithm
- **Queue 1**: Lottery scheduling with ticket-based probability
- **Queue 2**: Traditional round-robin
- **Time limits**: 1 tick (Q1), 2 ticks (Q2)
- **Boost interval**: 64 ticks

### Data Structures
```c
struct syscall_stat {
    char syscall_name[16];
    int count;
    int accum_time;
};

struct pstat {
    int pid[NPROC];
    int inuse[NPROC];
    int inQ[NPROC];
    int tickets_original[NPROC];
    int tickets_current[NPROC];
    int time_slices[NPROC];
};
```

## Files Modified/Added

### Modified Files
- `kernel/proc.c` - MLFQ scheduler implementation
- `kernel/syscall.c` - System call tracking
- `kernel/sysproc.c` - New system calls
- `Makefile` - Added user programs

### New Files
- `kernel/pstat.h` - Process statistics structure
- `kernel/syscall_stat_track.h` - Syscall tracking structure
- `user/history.c` - History user program
- `user/dummyproc.c` - Scheduler testing program
- `user/testprocinfo.c` - Process info display program

## Configuration

Key parameters in `kernel/param.h`:
```c
#define TIME_LIMIT_1 1           // Queue 1 time limit
#define TIME_LIMIT_2 2           // Queue 2 time limit  
#define BOOST_INTERVAL 64        // Priority boost interval
#define DEFAULT_TICKET_COUNT 10  // Default tickets per process
#define PRINT_SCHEDULING 0       // Debug output (set to 1 for testing)
```

## Building & Testing

```bash
# Apply patch to fresh xv6
git apply 2105123.patch

# Build and run
make qemu

# Test system calls
history
dummyproc 15 &
testprocinfo
```

## Assignment Context

**Course**: CSE 314 - Operating Systems Sessional  
**Institution**: Bangladesh University of Engineering and Technology  
**Submission**: Patch file format


# 2105123_offline-3_IPC

# CSE 314: Operating System Sessional - IPC Assignment

## Overview
Implementation of Inter-Process Communication (IPC) using threads and synchronization primitives in C++. The assignment simulates a document distribution system with operatives working in groups, managing shared resources through proper synchronization mechanisms.

## Problem Description
- **N operatives** divided into groups of **M members** each
- **Two-phase operation**: Document Recreation → Logbook Entry
- **Shared Resources**: 4 typewriting stations, 1 master logbook
- **Synchronization Challenges**: Resource allocation, reader-writer problem

## Key Features
### Task 1: Station Assignment Protocol
- Operatives assigned to typewriting stations using `(operative_id % 4) + 1`
- No busy waiting implementation
- Proper notification system for waiting operatives

### Task 2: Intelligence Hub Access Control
- Reader-Writer problem implementation
- Multiple readers can access logbook simultaneously
- Writers (group leaders) have exclusive access
- Intelligence staff continuously monitor the logbook

## Implementation Details
- **Threading**: POSIX threads (pthread)
- **Synchronization**: Mutexes, Semaphores
- **Timing**: Poisson distribution for realistic arrival patterns
- **No Busy Waiting**: Semaphore-based coordination

## Input Format
```
N M
x y
```
- N: Number of operatives
- M: Unit size (N must be divisible by M)
- x: Document recreation time
- y: Logbook entry time

## Compilation & Execution
```bash
g++ -pthread 2105123.cpp -o a.out
./a.out input.txt output.txt
```

## Sample Output
```
Operative 4 has arrived at typewriting station at time 4
Intelligence Staff 1 began reviewing logbook at time 13. Operations completed = 0
Operative 4 has completed document recreation at time 14
Unit 1 has completed document recreation phase at time 60
Unit 2 has completed intelligence distribution at time 95
```

## Technical Components
- **Mutex locks**: Thread-safe operations
- **Semaphores**: Resource management and reader-writer synchronization
- **Random delays**: Poisson distribution simulation
- **Comprehensive logging**: Detailed timing information

