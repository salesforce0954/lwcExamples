import { LightningElement } from 'lwc';

export default class Pagination extends LightningElement {

    handlePrevious(){

        const prev = new CustomEvent('previous');
        this.dispatchEvent(prev);
    }

    handleNext(){

        const nxt = new CustomEvent('next');
        this.dispatchEvent(nxt);
    }
}