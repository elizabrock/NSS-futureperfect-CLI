NSS-futureperfect-CLI
=====================

Purpose
-------

This is my example project for the Unit 2 (Ruby) Capstone project for Nashville Software School Software Development Fundamentals course.

The contstraints of the project are that they must use standard library Ruby with the exception of being able to use ActiveRecord as an ORM.  Future exceptions may be added, but the concept with this capstone is to demonstrate mastery of Ruby itself.

The goal of this project is to create a rotating task-list, similar to the [iOS app 30/30](https://itunes.apple.com/us/app/30-30/id505863977?mt=8)

Project Status / TODO
---------------------

  1. The tests should use a test database
  2. `Project.destroy_all` is not the ideal solution for test prep
  3. Implement data validations

Features
--------
The main features of the futureperfect CLI will be that the tasks rotate until completed

Usage Instructions
------------------
Planned usage is as follows:

To add a new task:

    > fp add "My new task"

To view the list of all existing tasks:

    > fp list

To remove a new task:

    > fp remove "My new task"

To start working through your tasks:

    > fp start

When the task is complete, the terminal bell will ding and you will be prompted to move on to the next task ('n'), finish and move on ('f') or quit ('q')

While working through tasks, press:

	*  'f' to complete this task (stop working on it and mark it as finished)
	*  'n' to start the next task (if there is no task in progress)
	*  'p' to pause/unpause the current task
	*  'q' to quit working (exit the program)
  *  's' to skip this task (move it to the bottom of the queue)

Demo
----

To demo the app, you'll have to download it and try it yourself.

Known Bugs
----------
The great joy of having no code is having no bugs, no?

j/k.  Requirements bugs are *everywhere*.

Author
------

Eliza Brock

Changelog
---------

5/9/2013 - Created initial repository with README and user stories, as per students' assignment for 5/10

License
-------
Copyright (c) 2013 Eliza Brock

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
