% knowledge base
%For Adding new student,class,course
:- dynamic(student/3).
:- dynamic(class/3).
:- dynamic(course/4).
:- dynamic(instructor/3).
:- style_check(-singleton).
%student(id,[taken courses],Handicapped).
student(s1,[course1],no).
student(s2,[course2],no).
student(s3,[course3],handicapped).
student(s4,[course1,course2],handicapped).
student(s5,[course3,course2],no).
student(s6,[course3,course4],no).
student(s7,[course5,course4],no).
student(s8,[course2,course5],no).
student(s9,[course3,course5],handicapped).
student(s10,[course3,course6],handicapped).
student(s11,[course4,course6],no).

%instructor(id,[given courses],[preferences]).
instructor(i1,[course1,course5],[projector]).
instructor(i2,[course2,course6],[projector,smart_board]).
instructor(i3,[course3],[smart_board]).
instructor(i4,[course4],[projector,smart_board]).

%course(id,capacity,instructorID,[needs]).
course(course1,13,i1,[handicapped]).
course(course2,25,i2,[smart_board,projector]).
course(course3,16,i3,[projector]).
course(course4,9,i4,[handicapped,projector]).
course(course5,15,i1,[smart_board]).
course(course6,18,i2,[handicapped,smart_board,projector]).

%class(id,capacity,[equipment]).
class(class1,15,[projector,handicapped,no]).
class(class2,10,[smart_board,no]).
class(class3,30,[projector,no]).
class(class4,12,[smart_board,handicapped,no]).
class(class5,20,[projector,smart_board,handicapped,no]).

%occupied(course,class,start).
occupied(course1,class1,8).
occupied(course1,class1,9).%--->1
occupied(course2,class5,8).
occupied(course2,class5,9).
occupied(course2,class5,10).%--->2
occupied(course3,class3,10).
occupied(course3,class3,11).
occupied(course3,class3,12).
occupied(course4,class1,9).%conflict1
occupied(course4,class1,10).
occupied(course4,class1,11).
occupied(course5,class4,12).
occupied(course5,class4,13).
occupied(course6,class5,10).%conflict2
occupied(course6,class5,11).
occupied(course6,class5,12).
%For Adding Student
add_student(ID,Courses,Needs):-
    \+student(ID,_,_),
    assertz(student(ID,Courses,Needs)).
%For Adding Class
add_class(ID,Capacity,Equipments):-
    \+class(ID,_,_),
    assertz(class(ID,Capacity,Equipments)).
%For Adding Course
add_course(ID,Capacity,InstructorID,Needs):-
    \+course(ID,_,_,_),
    assertz(course(ID,Capacity,InstructorID,Needs)).

%To check which room can be assigned to a given class.
course_class(Course,Class):-
    course(Course,C1,_,Needs),
    class(Class,C2,Equipments),
    C1 =< C2,%To check whether the capacity of a class is enough for course capacity 
    subset(Needs,Equipments).

%To check whether a student can be enrolled to a given class
student_class(Student,Class):-    
    student(Student,_,Needs),
    class(Class,_,Equipments),
    in(Needs,Equipments).%Handicapped or not

%To check whether there is any scheduling conflict
check_conflict(Course1,Course2):-
    occupied(Course1,C1,T1),
    occupied(Course2,C2,T2),
    not(Course1=Course2),
    C1=C2,(T1=T2).%Same class,same time
%To check whether an element is in array
in(E, [E|Rest]).
in(E, [I|Rest]):-
	in(E, Rest).

%To check whether a list is a subset of a list 
subset([], B).
subset([E|Rest], B):-		
	element(E, B),
	subset(Rest, B).
%To check whether an element is in array
element(E, S):-
	in(E, S).