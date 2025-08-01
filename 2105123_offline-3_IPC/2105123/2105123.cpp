#include <chrono>
#include <fstream>
#include <iostream>
#include <pthread.h>
#include <random>
#include <unistd.h>
#include <vector>
#include <semaphore.h>
#define SLEEP_MULTIPLIER 1000
using namespace std;

int total_TS = 4;
int total_staff = 2;
int N;
int M;
int Document_Recreation_time_x;
int Logbook_Entry_time_y;
int G;

pthread_mutex_t typewriting_lock;
pthread_mutex_t output_lock;
pthread_mutex_t operation_count_lock;
// sem_t all_leader_entry_done_sem;
sem_t rw_sem_db;
sem_t read_count_sem_mutex;
int read_count = 0;
int operation_count = 0;

auto start_time = chrono::high_resolution_clock::now();

long long get_time()
{
  auto end_time = chrono::high_resolution_clock::now();
  auto duration = chrono::duration_cast<chrono::milliseconds>(
      end_time - start_time);
  long long elapsed_time_ms = duration.count();
  return elapsed_time_ms;
}

int get_random_number()
{
  random_device rd;
  mt19937 generator(rd());
  double lambda = 10000.234;
  poisson_distribution<int> poissonDist(lambda);
  return poissonDist(generator);
}
int start_activity = (get_random_number() % 5) + 1;
void write_output(string output)
{
  pthread_mutex_lock(&output_lock);
  cout << output << endl;
  pthread_mutex_unlock(&output_lock);
}
enum operative_state
{
  READY_TO_START,
  AT_TYPEWRITING_STATION,
  WAITING,
  TYPING,
  TYPE_COMPLETED,
  COLLECTING_ALL,
  FINISH_COLLECTING,
};
class OPERATIVE
{
public:
  int id;
  int writing_time;
  operative_state state;
  int group_id;
  int leader_id;
  int type_writer_station_id;
  // sem_t operative_lock;

  OPERATIVE(int id) : id(id), state(READY_TO_START)
  {
    writing_time = Document_Recreation_time_x;
    group_id = ((id - 1) / M) + 1;
    leader_id = group_id * M;
    type_writer_station_id = (id % total_TS) + 1;
    // sem_init(&operative_lock, 0, 0);
  }
};
class UNIT
{
public:
  int group_id;
  int typed_done;
  pthread_mutex_t unit_lock;
  bool logbook_written;
  UNIT(int id) : group_id(id)
  {
    typed_done = 0;
    pthread_mutex_init(&unit_lock, NULL);
    logbook_written=false;
  }
  bool all_memebers_Typed_done()
  {

    if (typed_done == M)
      return true;
    else
      return false;
  }
  int start_id()
  {
    return group_id * M - (M - 1);
  }
  int end_id()
  {
    return group_id * M;
  }
};
class TYPEWRITING_STATION
{
public:
  int id;
  // bool is_full;
  bool is_empty;
  sem_t access;
  TYPEWRITING_STATION(int id)
  {
    this->id = id;
    is_empty = true;
    sem_init(&access, 0, 1);
  }
  void acquire(int operative_id)
  {
     write_output("Operative " + to_string(operative_id) + " has arrived at typewriting station " +"at time " + to_string(get_time() / SLEEP_MULTIPLIER));
    sem_wait(&access);
    //write_output("Operative " + to_string(operative_id) + " has arrived at typewriting station " + to_string(id) + " at time " + to_string(get_time() / SLEEP_MULTIPLIER));
    is_empty = false;
  }

  void release(int operative_id)
  {
    write_output("Operative " + to_string(operative_id) + " has completed document recreation at time " + to_string(get_time() / SLEEP_MULTIPLIER));
    is_empty = true;
    sem_post(&access);
  }
  TYPEWRITING_STATION *getTS(int id)
  {
    if (this->id == id)
      return this;
    return nullptr;
  }
  ~TYPEWRITING_STATION()
  {
    sem_destroy(&access);
  }
};
class INTELLIGENT_STAFF
{
public:
  int id;
  INTELLIGENT_STAFF(int id)
  {
    this->id = id;
  }
};

vector<OPERATIVE> operative_list;
vector<UNIT> unit_list;
vector<TYPEWRITING_STATION> ts_list;
vector<INTELLIGENT_STAFF> staff_list;

void initialize()
{
  G = N / M;
  for (int i = 1; i <= N; i++)
  {
    operative_list.emplace_back(OPERATIVE(i));
  }
  for (int i = 1; i <= G; i++)
  {
    unit_list.emplace_back(UNIT(i));
  }
  for (int i = 1; i <= total_TS; i++)
  {
    ts_list.emplace_back(TYPEWRITING_STATION(i));
  }
  for (int i = 1; i <= total_staff; i++)
  {
    staff_list.emplace_back(INTELLIGENT_STAFF(i));
  }

  pthread_mutex_init(&typewriting_lock, NULL);
  pthread_mutex_init(&output_lock, NULL);
  pthread_mutex_init(&operation_count_lock,NULL);
  // sem_init(&all_leader_entry_done_sem,0,0);
  sem_init(&rw_sem_db, 0, 1);
  sem_init(&read_count_sem_mutex, 0, 1);

  start_time = chrono::high_resolution_clock::now();
}

void start_typing(OPERATIVE *operative)
{
  int operative_id = operative->id;
  int station_id = operative->type_writer_station_id;
  TYPEWRITING_STATION *ts = &ts_list[station_id - 1];
  sleep((get_random_number()%4+1));
  ts->acquire(operative_id);
  operative->state = TYPING;
}

void notify_all(OPERATIVE *operative)
{
  int operative_id = operative->id;
  for (int i = 1; i <= N; i++)
  {
    OPERATIVE *others = &operative_list[i - 1];
    if (others->type_writer_station_id == operative->type_writer_station_id && others->state == WAITING)
    {
      // write_output("notify others");
    }
    else
    {
      ;
    }
  }
}
int get_group_id(int leader_id)
{
  return (leader_id / M);
}
void write_logbook(int id)
{
  sem_wait(&rw_sem_db);
  // write_output("The leader "+to_string(id)+" is into the logbook "+ to_string(get_time()/SLEEP_MULTIPLIER));
  sleep(Logbook_Entry_time_y);
  pthread_mutex_lock(&operation_count_lock);
  operation_count++;
  pthread_mutex_unlock(&operation_count_lock);
  // write_output("The leader "+to_string(id)+" has finished writing in the logbbok "+to_string(get_time()/SLEEP_MULTIPLIER));
  write_output("Unit " + to_string(get_group_id(id)) + " has completed intelligence distribution at time " + to_string(get_time() / SLEEP_MULTIPLIER));
  sem_post(&rw_sem_db);
}
void end_typing(OPERATIVE *operative)
{
  int operative_id = operative->id;
  TYPEWRITING_STATION *ts = &ts_list[operative->type_writer_station_id - 1];
  ts->is_empty = true;
  operative->state = TYPE_COMPLETED;
  notify_all(operative);
  ts->release(operative_id);  
  pthread_mutex_lock(&unit_list[operative->group_id - 1].unit_lock);
  unit_list[operative->group_id - 1].typed_done += 1;

  if (unit_list[operative->group_id - 1].typed_done == M &&
      !unit_list[operative->group_id - 1].logbook_written)
  {
      unit_list[operative->group_id - 1].logbook_written = true; 
      pthread_mutex_unlock(&unit_list[operative->group_id - 1].unit_lock); 
      write_output("Unit " + to_string(operative->group_id) + " has completed document recreation phase at time " + to_string(get_time() / SLEEP_MULTIPLIER));
      write_logbook(operative->leader_id); 
  }
  else
  {
      pthread_mutex_unlock(&unit_list[operative->group_id - 1].unit_lock);
  }

  // notify_all(operative);
  // ts->release(operative_id);
}

void *operative_activities(void *arg)
{
  OPERATIVE *operative = (OPERATIVE *)arg;
  usleep((get_random_number()%3) * SLEEP_MULTIPLIER);
  start_typing(operative);
  sleep(operative->writing_time);
  end_typing(operative);
  return NULL;
}

void *reader_staff(void *arg)
{
  INTELLIGENT_STAFF *staff = (INTELLIGENT_STAFF *)arg;
 // usleep(start_activity*SLEEP_MULTIPLIER);
  while (true)
  {
    usleep(((get_random_number()%2)+1)*SLEEP_MULTIPLIER);
    //usleep(get_random_number() * SLEEP_MULTIPLIER);
    sem_wait(&read_count_sem_mutex);
    read_count = read_count + 1;
    if (read_count == 1)
    {
      sem_wait(&rw_sem_db);
    }
    // write_output("Intelligence Staff "+to_string(staff->id)+" began reviewing logbook at time "+to_string(get_time()/SLEEP_MULTIPLIER)+". Operations completed = "+to_string(operation_count));
    sem_post(&read_count_sem_mutex);

    // write_output("Intelligence Staff "+to_string(staff->id)+" began reviewing logbook at time "+to_string(get_time()/SLEEP_MULTIPLIER)+". Operations completed = "+to_string(operation_count));
    write_output("Intelligence Staff " + to_string(staff->id) + " began reviewing logbook at time " + to_string(get_time() / SLEEP_MULTIPLIER) + ". Operations completed = " + to_string(operation_count));
    sleep(Logbook_Entry_time_y);
    sem_wait(&read_count_sem_mutex);
    read_count = read_count - 1;
    if (read_count == 0)
    {
      sem_post(&rw_sem_db);
    }
    sem_post(&read_count_sem_mutex);
   sleep(get_random_number()%5+1);
  }
  return NULL;
}
int main(int argc, char *argv[])
{

  if (argc != 3)
  {
    cout << "Usage: ./a.out <input_file> <output_file>" << endl;
    return 0;
  }

  ifstream inputFile(argv[1]);
  streambuf *cinBuffer = cin.rdbuf();
  cin.rdbuf(inputFile.rdbuf());

  ofstream outputFile(argv[2]);
  streambuf *coutBuffer = cout.rdbuf();
  cout.rdbuf(outputFile.rdbuf());

  cin >> N;
  cin >> M;
  cin >> Document_Recreation_time_x;
  cin >> Logbook_Entry_time_y;
  if (N % M != 0)
  {
    cout << "The M must be multiple of N" << endl;
    return 1;
  }

  pthread_t operative_threads[N];
  pthread_t intelligence_staff_threads[N];

  initialize();
  for (int i = 0; i < total_staff; i++)
  {
    pthread_create(&intelligence_staff_threads[i], NULL, reader_staff, &staff_list[i]);
    usleep((get_random_number()%3+1)*SLEEP_MULTIPLIER);
  }
  int remainingStudents = N;
  bool started[N];
  for (int i = 0; i < N; i++)
  {
    started[i] = false;
  }
  while (remainingStudents)
  {
    int randomStudent = get_random_number() % N;
    if (!started[randomStudent])
    {
      started[randomStudent] = true;
      pthread_create(&operative_threads[randomStudent], NULL, operative_activities,
                     &operative_list[randomStudent]);
      remainingStudents--;
      usleep((get_random_number()%1000+1)*SLEEP_MULTIPLIER);
      if (get_time() > 7000)
      {
        break;
      }
    }
  }

  for (int i = 0; i < N; i++)
  {
    if (!started[i])
    {
      pthread_create(&operative_threads[i], NULL, operative_activities,
                     &operative_list[i]);
      usleep((get_random_number()%1000 + 1)*SLEEP_MULTIPLIER);    
     //usleep(1000);           
    }
  }

  for (int i = 0; i < N; i++)
  {
    pthread_join(operative_threads[i], NULL);
  }
  sleep(2 * Logbook_Entry_time_y);
  for (int i = 0; i < total_staff; i++) {
      pthread_cancel(intelligence_staff_threads[i]); 
  }


  cin.rdbuf(cinBuffer);
  cout.rdbuf(coutBuffer);
  return 0;
}

//g++ -pthread 2105123.cpp -o a.out
//./a.out input.txt out.txt