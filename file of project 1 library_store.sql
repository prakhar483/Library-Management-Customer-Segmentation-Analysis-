create database library_store;
-- now use the database 
use  library_store;
create table authors(
book_authors_bookid int primary key auto_increment,
book_authors_authorname varchar(100)
);
create table publisher(
publisher_Publishername varchar(255) primary key,
publisher_Publisheraddress text,
publisher_Publisherphone varchar(50)
);

create table books(
book_bookid int primary key auto_increment,
book_title varchar(255),
book_publishername varchar(255),
foreign key (book_publishername) references publisher(publisher_Publishername)
);

create table library_branch(
library_branch_Branchid int primary key auto_increment,
library_branch_Branchname varchar(255),
library_branch_Branchaddress varchar(255)
);

create table book_copies(
book_copies_copiesid int primary key auto_increment,
book_copies_bookid int,
book_copies_branchid int,
book_copies_No_of_copies int,
foreign key (book_copies_bookid) references books (book_bookid),
foreign key (book_copies_branchid) references library_branch(library_branch_Branchid)
);

create table borrower(
borrower_Cardno int primary key auto_increment,
borrower_Borrowername varchar(150),
borrower_Borroweraddress varchar(255),
borrower_Borrowerphone varchar(50)
);

create table book_loans(
book_loans_Loansid int primary key auto_increment,
book_loans_Bookid int,
book_loans_Branchid int,
book_loans_Cardno int,
book_loans_Dateout varchar(100),
book_loans_Duedate varchar(100),
foreign key (book_loans_Bookid) references books (book_bookid),
foreign key (book_loans_Branchid) references library_branch(library_branch_Branchid),
foreign key (book_loans_Cardno) references borrower(borrower_Cardno)
);

-- Que->1 How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?
select bc.book_copies_No_of_copies from book_copies as bc
join books as b on book_bookid = bc.book_copies_bookid
join library_branch as lb on lb.library_branch_Branchid = bc.book_copies_branchid
where b.book_title = 'The Lost Tribe' and lb.library_branch_Branchname = 'Sharpstown';

-- Que->2 How many copies of the book titled "The Lost Tribe" are owned by each library branch?
select bc.book_copies_No_of_copies,lb.library_branch_Branchname from book_copies as bc
join books as b on book_bookid = bc.book_copies_bookid
join library_branch as lb on lb.library_branch_Branchid = bc.book_copies_branchid
where b.book_title = 'The Lost Tribe';

-- Que->3 Retrieve the names of all borrowers who do not have any books checked out.
select b.borrower_Borrowername from borrower as b
left join book_loans as bl on bl.book_loans_Cardno = b.borrower_Cardno
where bl.book_loans_Cardno is null;

-- Que-> 4 For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, retrieve the book title, the borrower's name, and the borrower's address. 
select b.book_title,br.borrower_Borrowername,br.borrower_Borroweraddress from books as b
join book_loans as bl on bl.book_loans_Bookid = b.book_bookid
join borrower as br on br.borrower_Cardno = bl.book_loans_Cardno
join library_branch as lb on lb.library_branch_Branchid = bl.book_loans_Branchid
where lb.library_branch_Branchname = 'Sharpstown' and bl.book_loans_Duedate = '2/3/18';

-- Que->5 For each library branch, retrieve the branch name and the total number of books loaned out from that branch.
select lb.library_branch_Branchname,count(bl.book_loans_Branchid) as total_no_of_books_loaned_books from book_loans as bl
join library_branch as lb on lb.library_branch_Branchid = bl.book_loans_Branchid
group by lb.library_branch_Branchname;

-- Que-> 6 Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.
select br.borrower_Borrowername,br.borrower_Borroweraddress,count(bl.book_loans_Cardno) as total_no_books_checkedout from book_loans as bl
join borrower as br on br.borrower_Cardno = bl.book_loans_Cardno
group by br.borrower_Cardno,br.borrower_Borrowername,br.borrower_Borroweraddress
having total_no_books_checkedout >5;

-- Que-> 7 For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".
select b.book_title,bc.book_copies_No_of_copies from book_copies as bc
join books as b on book_bookid = bc.book_copies_bookid
join authors as a on a.book_authors_bookid = b.book_bookid
join library_branch as lb on lb.library_branch_Branchid = bc.book_copies_branchid
where a.book_authors_authorname = 'Stephen King' and lb.library_branch_Branchname = 'Central';