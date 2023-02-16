

import dao.BookDao;
import daoimpl.BookDaoImpl;
import model.Books;

public class AccessBook {

    public static void main(String[] args) {

        BookDao bookDao = new BookDaoImpl();

        for (Books book : bookDao.getAllBooks()) {
            System.out.println("Book ISBN : " + book.getIsbn());
            System.out.println("Book name : " + book.getBookName());
        }

        //update student
        Books book = bookDao.getAllBooks().get(1);
        book.setBookName("Algorithms");
        bookDao.saveBook(book);

        for (Books book2 : bookDao.getAllBooks()) {
            System.out.println("New Book name : " + book2.getBookName());
        }
    }
}
