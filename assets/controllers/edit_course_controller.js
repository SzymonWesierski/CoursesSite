import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
    static targets = ['section', 'chapterList', 'chapterFormMessages'];

    connect() {
        const initialSectionIndex = parseInt(this.element.dataset.editCourseInitialSection, 10) || 0;
        this.showSection(initialSectionIndex);
    }

    navigate(event) {
        const index = parseInt(event.currentTarget.dataset.index);
        this.showSection(index);
    }

    showSection(index) {
        this.sectionTargets.forEach((section, i) => {
            section.style.display = i === index ? 'block' : 'none';
        });

        const currentUrl = window.location.pathname.split('/');
        const newSection = index;

        if (currentUrl.length > 4) {
            currentUrl[4] = newSection;
        } else {
            currentUrl.push(newSection);
        }
        const newUrl = currentUrl.join('/');
        window.history.pushState({ path: newUrl }, '', newUrl);
    }

    submitChapterForm(event) {
        event.preventDefault();

        const formData = new FormData(this.element.querySelector('#ajax-chapter-form'));
        const createChapterUrl = "/chapter/create";
        
        fetch(createChapterUrl, {
            method: 'POST',
            body: formData
        })
        .then(response => response.json())
        .then(data => {
            if (data.status === 'success') {
                const chapterCount = this.chapterListTarget.children.length + 1;
                const newChapterHtml = `
                    <div class="edit-course-chapter-element">
                        <div class="chapter-header">
                            <h3>Chapter.${chapterCount} </h3>
                            <div class="chapter-buttons">
                                <button class="btn-default edit-course-edit-delete-btn" 
                                        type="button" 
                                        data-controller="custom-modal" 
                                        data-action="click->custom-modal#open" 
                                        data-modal-id="edit-chapter" 
                                        data-chapter-id="${data.chapter.id}">
                                    <span>
                                        <img src="/icons/edit-white.svg" alt="edit">
                                    </span>
                                </button>

                                <button class="btn-default edit-course-edit-delete-btn" 
                                        type="button"
                                        data-controller="custom-modal" 
                                        data-action="click->custom-modal#open" 
                                        data-modal-id="delete-chapter"
                                        data-chapter-id="${data.chapter.id}">
                                    <span>
                                        <img src="/icons/remove.svg" alt="remove">
                                    </span>
                                </button>
                            </div>
                            <h3>${data.chapter.name} </h3>
                        </div>
                        
                        <div class="edit-course-episode-container">
                            <p> - - No episodes yet</p>
                        </div>
                            <button class="btn-default" 
                                    type="button" 
                                    data-controller="custom-modal" 
                                    data-action="click->custom-modal#open"
                                    data-modal-id="create-episode"
                                    data-chapter-id="${data.chapter.id}">
                                <span>
                                    <img src="/icons/plus.svg" alt="plus">
                                    Add episode
                                </span>
                            </button>
                    </div>
                `;
                this.chapterFormMessagesTarget.innerHTML = "";
                this.chapterListTarget.insertAdjacentHTML('beforeend', newChapterHtml);
                this.element.querySelector('#ajax-chapter-form').reset();
            } else {
                if (data.chapter.errors && typeof data.chapter.errors === 'object') {
                    let errorMessages = '';
                    
                    for (let key in data.chapter.errors) {
                        if (data.chapter.errors.hasOwnProperty(key)) {
                            errorMessages += `<p>${data.chapter.errors[key]}</p>`;
                        }
                    }
            
                    this.chapterFormMessagesTarget.innerHTML = errorMessages;
                }else{
                    this.chapterFormMessagesTarget.innerHTML = '<p>An error occurred222.</p>';
                }
            }
        })
        .catch(error => {
            console.error('Error:', error);

            this.chapterFormMessagesTarget.innerHTML = "<p style=\"color:red;\">Invalid title</p>";
        });
    }
}
