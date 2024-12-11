import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    static values = {
        userId: String,
    }

    static targets = ["button"];
    
    async resendEmail(event) {
        event.preventDefault();

        const button = this.buttonTarget;
        button.disabled = true;

        try {
            const response = await fetch("/email/resend", {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded", 
                },
                body: `id=${encodeURIComponent(this.userIdValue)}`,
            });

            const result = await response.json();

            if (result.status === "success") {
                alert("Verification email sent successfully!");
            } else {
                alert(result.message || "Something went wrong!");
            }
        } catch (error) {
            alert("An error occurred while sending the email.");
        } finally {
            button.disabled = false;
        }
    }
}
