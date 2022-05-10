import { LightningElement,api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
 
 
export default class MovieTile extends LightningElement {
    @api sushantMovies;
}