import java.util.*;
import java.time.*;
import java.time.temporal.ChronoUnit;

public class Main {

    // -------- Book Class --------
    static class Book {
        int id;
        String title;
        String author;
        boolean isIssued;

        Book(int id, String title, String author) {
            this.id = id;
            this.title = title;
            this.author = author;
            this.isIssued = false;
        }

        public String toString() {
            return id + " | " + title + " by " + author + (isIssued ? " [Issued]" : "");
        }
    }

    // -------- User Class --------
    static class User {
        int id;
        String name;

        User(int id, String name) {
            this.id = id;
            this.name = name;
        }
    }

    // -------- Transaction Class --------
    static class Transaction {
        Book book;
        User user;
        LocalDate issueDate;
        LocalDate dueDate;

        Transaction(Book book, User user) {
            this.book = book;
            this.user = user;
            this.issueDate = LocalDate.now();
            this.dueDate = issueDate.plusDays(7);
        }

        long calculateFine() {
            LocalDate today = LocalDate.now();
            if (today.isAfter(dueDate)) {
                return ChronoUnit.DAYS.between(dueDate, today) * 5;
            }
            return 0;
        }
    }

    // -------- Library Logic --------
    static class Library {
        List<Book> books = new ArrayList<>();
        List<User> users = new ArrayList<>();
        Map<Integer, Transaction> issuedBooks = new HashMap<>();

        void addBook(Book book) {
            books.add(book);
            System.out.println("Book added.");
        }

        void registerUser(User user) {
            users.add(user);
            System.out.println("User registered.");
        }

        void issueBook(int bookId, int userId) {
            Book book = findBook(bookId);
            User user = findUser(userId);

            if (book == null || user == null) {
                System.out.println("Invalid book/user.");
                return;
            }

            if (book.isIssued) {
                System.out.println("Book already issued.");
                return;
            }

            Transaction tx = new Transaction(book, user);
            issuedBooks.put(bookId, tx);
            book.isIssued = true;

            System.out.println("Book issued. Due date: " + tx.dueDate);
        }

        void returnBook(int bookId) {
            if (!issuedBooks.containsKey(bookId)) {
                System.out.println("Book not issued.");
                return;
            }

            Transaction tx = issuedBooks.remove(bookId);
            tx.book.isIssued = false;

            long fine = tx.calculateFine();
            if (fine > 0) {
                System.out.println("Late return. Fine: ₹" + fine);
            } else {
                System.out.println("Book returned successfully.");
            }
        }

        void searchBook(String keyword) {
            boolean found = false;
            for (Book b : books) {
                if (b.title.toLowerCase().contains(keyword.toLowerCase()) ||
                    b.author.toLowerCase().contains(keyword.toLowerCase())) {
                    System.out.println(b);
                    found = true;
                }
            }
            if (!found) System.out.println("No books found.");
        }

        private Book findBook(int id) {
            for (Book b : books) {
                if (b.id == id) return b;
            }
            return null;
        }

        private User findUser(int id) {
            for (User u : users) {
                if (u.id == id) return u;
            }
            return null;
        }
    }

    // -------- Main Method --------
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        Library lib = new Library();

        while (true) {
            System.out.println("\n1.Add Book 2.Register User 3.Issue 4.Return 5.Search 6.Exit");
            int choice = sc.nextInt();
            sc.nextLine();

            switch (choice) {
                case 1:
                    System.out.print("Enter book id: ");
                    int id = sc.nextInt();
                    sc.nextLine();
                    System.out.print("Enter title: ");
                    String title = sc.nextLine();
                    System.out.print("Enter author: ");
                    String author = sc.nextLine();
                    lib.addBook(new Book(id, title, author));
                    break;

                case 2:
                    System.out.print("Enter user id: ");
                    int uid = sc.nextInt();
                    sc.nextLine();
                    System.out.print("Enter name: ");
                    String name = sc.nextLine();
                    lib.registerUser(new User(uid, name));
                    break;

                case 3:
                    System.out.print("Enter bookId and userId: ");
                    lib.issueBook(sc.nextInt(), sc.nextInt());
                    break;

                case 4:
                    System.out.print("Enter bookId: ");
                    lib.returnBook(sc.nextInt());
                    break;

                case 5:
                    System.out.print("Enter keyword: ");
                    String keyword = sc.nextLine();
                    lib.searchBook(keyword);
                    break;

                case 6:
                    System.out.println("Exiting...");
                    System.exit(0);
            }
        }
    }
}
