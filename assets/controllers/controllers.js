import { Application } from '@hotwired/stimulus';
import OwlCarouselController from './owl_carousel_controller';
import FormStepperController from './form_stepper_controller';
import EditCourseController from './edit_course_controller';
import ModalController from './custom_modal_controller';
import ResendEmailController from './resend_email_controller';
import NavMenuController from './nav-menu-controller';

const application = Application.start();

application.register('owl-carousel', OwlCarouselController);

application.register('form-stepper', FormStepperController);

application.register('custom-modal', ModalController);

application.register('edit-course', EditCourseController);

application.register('resend-email', ResendEmailController);

application.register('nav-menu', NavMenuController);



const context = require.context('./', true, /\.js$/);
application.load(definitionsFromContext(context));



