/* Tests cetegorical mutual exclusion with different numbers of threads.
 * Automatic checks only catch severe problems like crashes.
 */
#include <stdio.h>
#include "tests/threads/tests.h"
#include "threads/malloc.h"
#include "threads/synch.h"
#include "threads/thread.h"
#include "lib/random.h" //generate random numbers
#include "devices/timer.h"

#define BUS_CAPACITY 3
#define SENDER 0
#define RECEIVER 1
#define NORMAL 0
#define HIGH 1
#define START -1 /* For the initial calling task to decide the initial direction */
#define TASKDIR task.direction
#define TASKPRIO task.priority

#define TIMEINBUS 10 /* Waiting sleep ticks for passing the bus */

/*
 *	initialize task with direction and priority
 *	call o
 * */
typedef struct {
	int direction;
	int priority;
} task_t;

/* Tasks wil be waiting to get on the bus, but in two directions and both for normal and high priority tasks.
 * We use a semaphore consisting of an array of two conditon variables. */
static struct semaphore high_prio_queue[2]; // priority queue
static struct semaphore norm_prio_queue[2]; // norm queuee

/* To ensure mutual exclusion */
static struct lock lock;

/* It will be necessary to know the number of tasks in the bus (initialized to 0) */
static int slots_used;

/* It will also be useful to know the number of tasks waiting to go in each direction so we use two arrays, 
   one for high priority tasks and the other for normal priority tasks. */
static int waiting_high_prio[2];
static int waiting_norm_prio[2];

/* It will be also necessary to know the current direction */
static int current_dir;

void batchScheduler(unsigned int num_tasks_send, unsigned int num_task_receive,
        unsigned int num_priority_send, unsigned int num_priority_receive);

void senderTask(void *);
void receiverTask(void *);
void senderPriorityTask(void *);
void receiverPriorityTask(void *);
void init_bus(void);


void oneTask(task_t task);/*Task requires to use the bus and executes methods below*/
	void getSlot(task_t task); /* task tries to use slot on the bus */
	void transferData(task_t task); /* task processes data on the bus either sending or receiving based on the direction*/
	void leaveSlot(task_t task); /* task release the slot */

/* Initializes semaphores, locks and variables */ 
void init_bus(void){ 
 
    random_init((unsigned int)123456789); 
    
    /* Iniciate the semaphors and the lock */
    sema_init(&high_prio_queue[0], 0);
    sema_init(&high_prio_queue[1], 0);
    sema_init(&norm_prio_queue[0], 0);
    sema_init(&norm_prio_queue[1], 0);
    lock_init(&lock);
    
    /* Iniciate variables */
    slots_used = 0;
    waiting_high_prio[0] = 0;
    waiting_high_prio[1] = 0;
    waiting_norm_prio[0] = 0;
    waiting_norm_prio[1] = 0;
    
    /* No decided direction yet*/
    current_dir = START;
}

/*
 *  Creates a memory bus sub-system  with num_tasks_send + num_priority_send
 *  sending data to the accelerator and num_task_receive + num_priority_receive tasks
 *  reading data/results from the accelerator.
 *
 *  Every task is represented by its own thread. 
 *  Task requires and gets slot on bus system (1)
 *  process data and the bus (2)
 *  Leave the bus (3).
 */

void batchScheduler(unsigned int num_tasks_send, unsigned int num_task_receive,
        unsigned int num_priority_send, unsigned int num_priority_receive)
{
    unsigned int i;
    /* create sender threads */
    for(i = 0; i < num_tasks_send; i++)
        thread_create("sender_task", 1, senderTask, NULL);

    /* create receiver threads */
    for(i = 0; i < num_task_receive; i++)
        thread_create("receiver_task", 1, receiverTask, NULL);

    /* create high priority sender threads */
    for(i = 0; i < num_priority_send; i++)
       thread_create("prio_sender_task", 1, senderPriorityTask, NULL);

    /* create high priority receiver threads */
    for(i = 0; i < num_priority_receive; i++)
       thread_create("prio_receiver_task", 1, receiverPriorityTask, NULL);
}

/* Normal task,  sending data to the accelerator */
void senderTask(void *aux UNUSED){
        task_t task = {SENDER, NORMAL};
        oneTask(task);
}

/* High priority task, sending data to the accelerator */
void senderPriorityTask(void *aux UNUSED){
        task_t task = {SENDER, HIGH};
        oneTask(task);
}

/* Normal task, reading data from the accelerator */
void receiverTask(void *aux UNUSED){
        task_t task = {RECEIVER, NORMAL};
        oneTask(task);
}

/* High priority task, reading data from the accelerator */
void receiverPriorityTask(void *aux UNUSED){
        task_t task = {RECEIVER, HIGH};
        oneTask(task);
}

/* abstract task execution*/
void oneTask(task_t task) {
  getSlot(task);
  transferData(task);
  leaveSlot(task);
}


/* task tries to get slot on the bus subsystem */
void getSlot(task_t task) {
    lock_acquire(&lock);
    
    /* For the initial calling task, decide the current direction */
    if(current_dir == START){
        current_dir = TASKDIR;
    }
    
    if(TASKPRIO == HIGH){ /* High priority tasks */
        /* Reduces race conditions */
        /* We wait if there are no free slots or wrong direction */
        while(slots_used == BUS_CAPACITY || (slots_used > 0 && current_dir != TASKDIR)){
            waiting_high_prio[TASKDIR]++;
            lock_release(&lock);
            sema_down(&high_prio_queue[TASKDIR]);
            lock_acquire(&lock);
            waiting_high_prio[TASKDIR]--;
        }
    } else{ /* Low priority tasks*/
        /* Reduces race conditions */
        /* We wait if there are any waiting high priority tasks, or there are no free slots and we can't change direction */
        while(slots_used == BUS_CAPACITY || (slots_used > 0 && current_dir != TASKDIR) || (waiting_high_prio[0] + waiting_high_prio[1]) > 0){
            waiting_norm_prio[TASKDIR]++;
            lock_release(&lock);
            sema_down(&norm_prio_queue);
            lock_acquire(&lock);
            waiting_norm_prio[TASKDIR]--;
        }
    }
    /* Got place at the bus */
    slots_used++;
    current_dir = TASKDIR;
    lock_release(&lock);
}

/* task processes data on the bus send/receive */
void transferData(task_t task) {
    /* Check to avoid possible problems */
    ASSERT(slots_used <= BUS_CAPACITY);
    
    /* Converting the random numbers to very long integers */
    unsigned int random = (unsigned int)random_ulong();
    random = random % TIMEINBUS;
    
    
    /* Sleeping the thread from 0 to TIMEINBUS ticks */
    timer_sleep((int64_t)random);
}

/* task releases the slot */
void leaveSlot(task_t task) {
    lock_acquire(&lock);
    slots_used--;
    
    /* First we check if there are any high prio tasks on the same side for waking them up */
    if(waiting_high_prio[TASKDIR]){
        sema_up(&high_prio_queue[TASKDIR]);
    } else if(slots_used == 0 && waiting_high_prio[1-TASKDIR]){ /* If the bus is free and there are any high priority tasks on the other side, we wake them up */
        current_dir = 1 - TASKDIR;
        
        /* Wake up high priority tasks */
        int tmp_free_slots = BUS_CAPACITY;
        int i;
        
        for(i = 0; i < waiting_high_prio[1-TASKDIR] && tmp_free_slots > 0; i++){
            tmp_free_slots--;
            sema_up(&high_prio_queue[1-TASKDIR]);
        }
    }
    else if(!waiting_high_prio[1-TASKDIR] && waiting_norm_prio[TASKDIR]){ /* Then if we can wake a normal task on the same side */
        sema_up(&norm_prio_queue[TASKDIR]);
    } else if(slots_used == 0){ /* If there are things waiting from the other direcion we can change direction if the bus is empty */
        current_dir = 1 - TASKDIR;
        
        int tmp_free_slots = BUS_CAPACITY;
        int i;
        
        /* First wake high priority tasks */
        for(i = 0; i < waiting_high_prio[1-TASKDIR] && tmp_free_slots > 0; i++){
            tmp_free_slots--;
            sema_up(&high_prio_queue[1-TASKDIR]);
        }
        
        /* Then normal priority tasks */
        for(i = 0; i < waiting_norm_prio[1-TASKDIR] && tmp_free_slots > 0; i++){
            tmp_free_slots--;
            sema_up(&norm_prio_queue[1-TASKDIR]);
        }
    }
    lock_release(&lock);
}
