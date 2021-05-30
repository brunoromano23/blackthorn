import { LightningElement, api, track } from 'lwc';
import getEventsData from '@salesforce/apex/EventController.retrieveEventsAcceptedContact';
const columns = [
    {
        label: 'Id',
        fieldName: 'Id',
        type: 'text',
    }, 
    {
        label: 'Event Name',
        fieldName: 'EventName',
        type: 'text',
    }, 
    {
        label: 'Start Date/Time',
        fieldName: 'EventStart',
        type: 'datetime'
    }, 
    {
        label: 'End Date/Time',
        fieldName: 'EventEnd',
        type: 'datetime'
    }
];
export default class EventsRelatedList extends LightningElement {
    @api recordId;
    @track data = [];
    @track columns = columns;

    connectedCallback() {
        this.getEventsAcceptedData();
    }
    getEventsAcceptedData() {
        this.showSpinner = true;

        getEventsData({ accountId: this.recordId })
            .then(result => {
                    this.data = result;
                    if(this.data) {
                        let currentData = [];
                        this.data.forEach((row) => {
                            let rowData = {};
                            rowData.Id = row.Id;            
                            if (row.Event) {
                                rowData.EventName = row.Event.Subject;
                                rowData.EventStart = row.Event.StartDateTime;
                                rowData.EventEnd = row.Event.EndDateTime;
                            }
                            currentData.push(rowData);
                         });
                         this.data = currentData;
                    }
            })
            .catch(error => {
                this.showErrorToast(this.buildErrorMessage(error));
            });
    }

    buildErrorMessage(error) {
        if (error.status)
            return `${error.status} (${error.statusText}) ${error.body ? '- ' + error.body.message : ''}.`

        return `${error.body ? '- ' + error.body.message : ''}`;
    }
    showErrorToast(message) {
        const showToastEvent = new ShowToastEvent({
            message: message,
            variant: 'error'
        });

        this.dispatchEvent(showToastEvent);
    }

}