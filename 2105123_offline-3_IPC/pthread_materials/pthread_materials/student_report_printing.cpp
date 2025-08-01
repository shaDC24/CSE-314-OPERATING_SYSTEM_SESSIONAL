/*
  This program simulates a group of students completing and printing their
  reports. Each student has a random writing time before heading to a print
  station to log their arrival. The program reads the number of students from an
  input file, and writes each student's arrival time at the print station to an
  output file.

  Key points:
    - Each student has a unique ID and a random writing time between 1 and
  MAX_WRITING_TIME seconds.
    - Students "write" their reports, then arrive at the print station and log
  their arrival time.
    - Student actions are handled using threads, and each student's arrival is
  recorded in a thread-safe manner to prevent log mixing.

  Compilation:
    g++ -pthread student_report_printing.cpp -o a.out

  Usage:
    ./a.out <input_file> <output_file>

  Input:
    The input file should contain the number of students (N).
    Example of input file (in.txt):
    10

  Output:
    Each student's arrival time at the print station is logged in the output
  file.

  Prepared by: Nafis Tahmid (1905002), Date: 10 November 2024
*/

#include <chrono>
#include <fstream>
#include <iostream>
#include <pthread.h>
#include <random>
#include <unistd.h>
#include <vector>

// Constants
#define MAX_WRITING_TIME 20   // Maximum time a student can spend "writing"
#define WALKING_TO_PRINTER 10 // Maximum time taken to walk to the printer
#define SLEEP_MULTIPLIER 1000 // Multiplier to convert seconds to milliseconds

int N; // Number of students

// Mutex lock for output to file for avoiding interleaving
pthread_mutex_t output_lock;

// Timing functions
auto start_time = std::chrono::high_resolution_clock::now();

/**
 * Get the elapsed time in milliseconds since the start of the simulation.
 * @return The elapsed time in milliseconds.
 */
long long get_time() {
  auto end_time = std::chrono::high_resolution_clock::now();
  auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(
      end_time - start_time);
  long long elapsed_time_ms = duration.count();
  return elapsed_time_ms;
}

// Function to generate a Poisson-distributed random number
int get_random_number() {
  std::random_device rd;
  std::mt19937 generator(rd());

  // Lambda value for the Poisson distribution
  double lambda = 10000.234;
  std::poisson_distribution<int> poissonDist(lambda);
  return poissonDist(generator);
}

enum student_state { WRITING_REPORT, WAITING_FOR_PRINTING };

/**
 * Class representing a student in the simulation.
 */
class Student {
public:
  int id;              // Unique ID for each student
  int writing_time;    // Time student spends "writing"
  student_state state; // Current state of the student (writing or waiting)

  /**
   * Constructor to initialize a student with a unique ID and random writing
   * time.
   * @param id Student's ID.
   */
  Student(int id) : id(id), state(WRITING_REPORT) {
    writing_time = get_random_number() % MAX_WRITING_TIME + 1;
  }
};

std::vector<Student> students; // Vector to store all students

// uses mutex lock to write output to avoid interleaving
void write_output(std::string output) {
  pthread_mutex_lock(&output_lock);
  std::cout << output;
  pthread_mutex_unlock(&output_lock);
}

/**
 * Simulate arriving at the printing station and log the time.
 */
void start_printing(Student *student) {
  student->state = WAITING_FOR_PRINTING;

  write_output("Student " + std::to_string(student->id) +
               " has arrived at the print station at " +
               std::to_string(get_time()) + " ms\n");
}

/**
 * Initialize students and set the start time for the simulation.
 */
void initialize() {
  for (int i = 1; i <= N; i++) {
    students.emplace_back(Student(i));
  }

  // Initialize mutex lock
  pthread_mutex_init(&output_lock, NULL);

  start_time = std::chrono::high_resolution_clock::now(); // Reset start time
}

/**
 * Thread function for student activities.
 * Simulates the student's report writing and reaching the print station.
 * @param arg Pointer to a Student object.
 */
void *student_activities(void *arg) {
  Student *student = (Student *)arg;

  write_output("Student " + std::to_string(student->id) +
               " started writing for " + std::to_string(student->writing_time) +
               " ms at " + std::to_string(get_time()) + " ms\n");
  usleep(student->writing_time * SLEEP_MULTIPLIER); // Simulate writing time
  write_output("Student " + std::to_string(student->id) +
               " finished writing at " + std::to_string(get_time()) + " ms\n");

  usleep((get_random_number() % WALKING_TO_PRINTER + 1) *
         SLEEP_MULTIPLIER); // Simulate walking to printer
  start_printing(student);  // Student reaches the printing station

  return NULL;
}

int main(int argc, char *argv[]) {
  if (argc != 3) {
    std::cout << "Usage: ./a.out <input_file> <output_file>" << std::endl;
    return 0;
  }

  // File handling for input and output redirection
  std::ifstream inputFile(argv[1]);
  std::streambuf *cinBuffer = std::cin.rdbuf(); // Save original std::cin buffer
  std::cin.rdbuf(inputFile.rdbuf()); // Redirect std::cin to input file

  std::ofstream outputFile(argv[2]);
  std::streambuf *coutBuffer = std::cout.rdbuf(); // Save original cout buffer
  std::cout.rdbuf(outputFile.rdbuf()); // Redirect cout to output file

  // Read number of students from input file
  std::cin >> N;

  pthread_t student_threads[N]; // Array to hold student threads

  initialize(); // Initialize students and mutex lock

  int remainingStudents = N;
  bool started[N];

  // start student threads randomly
  while (remainingStudents) {
    int randomStudent = get_random_number() % N;
    if (!started[randomStudent]) {
      started[randomStudent] = true;
      pthread_create(&student_threads[randomStudent], NULL, student_activities,
                     &students[randomStudent]);
      remainingStudents--;
      usleep(1000); // sleep for 1 ms
      if (get_time() >
          7000) { // if more than 7 seconds is passed, initialize the rest
        break;
      }
    }
  }

  // after waiting for 7(our choice) secs, start the remaining student threadss
  for (int i = 0; i < N; i++) {
    if (!started[i]) {
      pthread_create(&student_threads[i], NULL, student_activities,
                     &students[i]);
    }
  }

  // Wait for all student threads to finish
  for (int i = 0; i < N; i++) {
    pthread_join(student_threads[i], NULL);
  }

  // Restore std::cin and cout to their original states (console)
  std::cin.rdbuf(cinBuffer);
  std::cout.rdbuf(coutBuffer);

  return 0;
}

/*
  Prepared by: Nafis Tahmid (1905002), Date: 10 November 2024
*/