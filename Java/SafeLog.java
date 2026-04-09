import java.util.Scanner;

public class PasswordValidator {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String password;

        while (true) {
            System.out.print("Enter password: ");
            password = sc.nextLine();

            boolean hasUpper = false;
            boolean hasDigit = false;

            // check uppercase and digit
            for (int i = 0; i < password.length(); i++) {
                char ch = password.charAt(i);

                if (Character.isUpperCase(ch)) {
                    hasUpper = true;
                }

                if (Character.isDigit(ch)) {
                    hasDigit = true;
                }
            }

            boolean isValid = true;

            // check length
            if (password.length() < 8) {
                System.out.println("Too short");
                isValid = false;
            }

            // check uppercase
            if (!hasUpper) {
                System.out.println("Missing uppercase letter");
                isValid = false;
            }

            // check digit
            if (!hasDigit) {
                System.out.println("Missing digit");
                isValid = false;
            }

            // final check
            if (isValid) {
                System.out.println("Password is valid");
                break;
            }

            System.out.println(); // for spacing
        }

        sc.close();
    }
}
