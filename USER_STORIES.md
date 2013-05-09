User Stories for FuturePerfect
==============================

As a client manager
In order to make sure I give each client their fair share of my time
I want to work on each client's work at equal intervals

  - User runs `fp start`
  - User is shown the next client/project to work on
  - The client/project is then moved to the bottom of the list
  - When all clients/projects have been worked on, the list repeats

As a client manager
In order to keep my list of clients up to date
I want to add a client/project to my list

  - User runs `fp add <client/project>`
  - Client/project is added to the list of projects

As a client manager
In order to keep my list of clients up to date
I want to mark particular client projects as completed

  - User runs `fp list` to see the list of projects with project numbers
  - User runs `fp finish <project_number>`

As a client manager
In order to keep foused
I want to see a countdown of time to spend on a particular project

  - Once a task is started it counts down from 30 minutes


As a client manager
In order to keep moving
I want to hear a ding when it's time to switch tasks

  - When the 30 minutes are up a ding is sounded


As a client manager
In order to be efficient with my time
I want to interact with the program while it is running

  - When the current task is complete, instead of exitting, the program should prompt me for the next action
  - Options are: next task ('n'), finish and move on ('f') or quit ('q')

As a client manager
In order to be efficient with my time
I want to be able to skip my current task if I complete it early

  - While a task is in progress:
    *  'f' to complete this task (stop working on it and mark it as finished)
    *  'q' to quit working (exit the program)
    *  's' to skip this task (move it to the bottom of the queue)

As a client manager
In order to deal with interruptions
I want to be able to pause/unpause my current task

  - While a task is in progress:
    *  'p' to pause/unpause the current task

As a client manager
In order to know how I've been doing at distributing my time
I want to see a report of time worked per client/project

  - Run `fp report` to see list of projects sorted by time worked
