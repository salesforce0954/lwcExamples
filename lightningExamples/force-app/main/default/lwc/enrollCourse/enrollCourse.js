import { LightningElement,api } from 'lwc';
 
export default class EnrollCourse extends LightningElement {
    @api courseDetailInfo=
    {
    courseName:'Lightning Web Component',
    courseDuration:'30 Days',
    courseFee:'Free', 
    courseRating:'*****',
    }
 
}