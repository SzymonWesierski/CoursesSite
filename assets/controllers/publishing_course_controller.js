import { Controller } from "@hotwired/stimulus";

export default class extends Controller {

    static targets = ["button","publishingContainer"];
    
    async publishCourse(event) {
        event.preventDefault();

        const button = this.buttonTarget;
        const courseId = event.currentTarget.getAttribute('data-course-id');
        button.disabled = true;
        
        try {
            const response = await fetch(`/courses/publishing/${courseId}`, {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded", 
                },
            });
            
            const result = await response.json();

            if (result.status === "success") {
                const newChapterHtml = `
                    <h3>Initial verification passed successfully. Now our team will proceed to verify the 
                        content of your course. You will receive a feedback message from the verification
                        via email</h3>
            
                    <div class="delete-course-buttons-container">
                        <button type="button" class="btn-default-red" data-action="click->publishing-course#refreshPage" aria-label="Close">Cancel</button>
                    </div>
                `;
                
                this.publishingContainerTarget.innerHTML = newChapterHtml;
            } else {
                const newChapterHtml = `
                    <h3>Initial verification revealed a few minor issues that need to be fixed:</h3>

                    <div class="validation-error">
                        ${result.validationMsg}               
                    </div>

                    <div class="delete-course-buttons-container">
                        <button type="button" class="btn-default-red"  data-action="click->custom-modal#hide" aria-label="Close">Close</button>
                    </div>
                `;

                this.publishingContainerTarget.innerHTML = newChapterHtml;

            }
        } catch (error) {
            alert("An error occurred while publishing the course.");
        } finally {
            button.disabled = false;
        }
    }

    refreshPage() {
        location.reload();
    }
}
