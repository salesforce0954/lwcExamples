import { LightningElement } from 'lwc';

export default class LifeCycleParent extends LightningElement {

    constructor(){
        super();
        console.log('Parent constructor is called');
    }
    connectedCallback(){
        console.log('Parent connected call back is called');
    }
    renderedCallback(){
        console.log('Parent rendered call back is called');
    }
    render(){
        console.log('Render Parent is called');
    }
    disconnectedCallback(){
        console.log('Disconnected Parent is called');
    }
}