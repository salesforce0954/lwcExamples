import LightningDatatable from 'lightning/datatable';
import TextWithTooltip from './textWithTooltip';

export default class CustomDatatableCmp extends LightningDatatable {
    static customTypes = {
        textWithTooltip: {
            template: TextWithTooltip,
            typeAttributes: ['status', 'description','currentRecord']
        }
    }
}