## Reading Diary

###### What is it?

The Reading Diary is a APP for people that like books and will write and save own reviews after finishing reading.
In this APP user can create own list of readed books, save review for each, add own rating, fix number of readed books and average time of reading for one book.

It uses free API from [Goodreads]( www.goodreads.com)

###### User Experience
**First screen:** List of books: show all saved books. Here user also can check statistics.
On the first screen user can search early saved book by the title or author.
While searching user can’t add new books or open statistics.
Tap to the book to open screen with information about book.

New book can be add two ways: manually or via the searching on the Goodreads.
Manually: will open screen with information about book with empty fields.
Via the searching: will open screen with searching on Goodreads

**Second screen:** Searching book on the Goodreads.
User can search book by the title or author.
With tap on the book will open the new screen with information about book.

**Third screen:**  Information about book.
Will be filled up in case user came from searching results or from first screen.
Will be  empty in case user choose "manually style" adding book.

Open book on Goodreads-button open link to the book in Safari ( require internet-connection)

Edit-button give opportunity to change or fill fields:
My stars (from 0 to 5)
Date of start of reading
Date of end of reading
Add review (will open screen with review)
Edit review (will open screen with review)

Save-button save the book and return user to the first screen with list of saved books.

**Fourth screen:** Review
User can write  a new review or edit existed.

**Fifth screen:** Statistics
Show statistics: number of readed books and average time of reading for one book.

###### Information for reviewer
Free API from [Goodreads]( www.goodreads.com)
Information about books save and storage in CoreData (PersistenceService file).
Statistics save and storage in NSUserDefaults(StatisticsRepository file).
Book-class represents NSManagedObject.
FoundBook represents struct for parsing results from xml-file from Goodreads.
For saving book required parameters: title and author. All other parameters are optional and doesn't influent to saving.

###### Licensing

This project is licensed under the MIT License - see the LICENSE.txt file for details

###### Authors

Anna Panova:  [GitHub Page]( https://github.com/AnnaPanova)

All pictures were free downloaded from [Flaticon] (https://www.flaticon.com)
[simple book cover](https://www.flaticon.com/free-icon/agenda_149809)
[book shelves](https://www.flaticon.com/free-icon/books_1258334#term=book%20shelves&page=1&position=9)
[opened book](https://www.flaticon.com/free-icon/open-book_182321#term=book&page=1&position=1)
[app’s icon](https://www.flaticon.com/free-icon/notebook_1049834#term=diary&page=3&position=56)

###### Contacts

If you have a concrete bug report for Apache please contact to me on email: annapanovadev@gmail.com

