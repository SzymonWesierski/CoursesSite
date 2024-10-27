import { Controller } from '@hotwired/stimulus';

export default class extends Controller {

   async open(event) {
        const modalId = event.currentTarget.getAttribute('data-modal-id');
        const modal = document.getElementById(modalId);

        if (modal) {  
            if(modalId === "edit-episode"){
                const courseId = event.currentTarget.getAttribute('data-course-id');
                const episodeId = event.currentTarget.getAttribute('data-episode-id');

                const courseInput = modal.querySelector('input[name="course_id"]');
                if (courseInput) courseInput.value = courseId;
    
                const episodeInput = modal.querySelector('input[name="episode_id"]');
                if (episodeInput) episodeInput.value = episodeId;

                try {
                    const response = await fetch(`/episodes/edit/${episodeId}/${courseId}`, {
                        headers: {
                            'X-Requested-With': 'XMLHttpRequest' 
                        }
                    });
                    if (response.ok) {
                        const html = await response.text();
                        modal.querySelector('.modal-body').innerHTML = html;

                        const courseInput = modal.querySelector('input[name="course_id"]');
                        if (courseInput) courseInput.value = courseId;
            
                        const episodeInput = modal.querySelector('input[name="episode_id"]');
                        if (episodeInput) episodeInput.value = episodeId;


                    } else {
                        console.error("Nie udało się załadować danych epizodu.");
                    }
                } catch (error) {
                    console.error("Błąd podczas pobierania danych epizodu:", error);
                }

            }
    
            if(modalId === "create-episode"){
                const chapterId = event.currentTarget.getAttribute('data-chapter-id');

                const chapterInput = modal.querySelector('input[name="chapter_id"]');
                if (chapterInput) chapterInput.value = chapterId;
            }
    
            if(modalId === "delete-episode"){
                const episodeId = event.currentTarget.getAttribute('data-episode-id');
                const courseId = event.currentTarget.getAttribute('data-course-id');
                const deleteButton = document.getElementById('deleteEpisodeButton');
                if (deleteButton) {
                    deleteButton.setAttribute(
                        'onclick',
                        `window.location.href='/episodes/delete/${episodeId}/${courseId}'`
                    );
                }
            }
            
        }

        
        // schow modal
        modal.classList.add('show');
        modal.style.display = 'block';
        modal.setAttribute('aria-hidden', 'false');
        document.body.classList.add('modal-open');

        const backdrop = document.createElement('div');
        backdrop.className = 'modal-backdrop fade show';
        document.body.appendChild(backdrop);
                
    }
    
    hide(event) {
        const modal = event.currentTarget.closest('.modal');
        
        if (modal) {
            modal.classList.remove('show');
            modal.style.display = 'none';
            modal.setAttribute('aria-hidden', 'true');
            document.body.classList.remove('modal-open');

            const backdrop = document.querySelector('.modal-backdrop');
            if (backdrop) {
                backdrop.remove();
            }
        }
    }
}
