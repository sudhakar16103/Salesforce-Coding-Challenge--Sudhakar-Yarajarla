import { LightningElement, api, wire, track } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';// This is used to close the quick action modal
import sendSMS from "@salesforce/apex/SMSQuickActionController.sendSMS";// import apex method to send SMS
import getPhoneNumbers from "@salesforce/apex/SMSQuickActionController.getPhoneNumbers";// import apex method to get all phone numbers
import { ShowToastEvent } from 'lightning/platformShowToastEvent';// import standard toast event


export default class LWCQuickActionTechdicer extends LightningElement {
    @api recordId;
    @api objectApiName;
    @track completedLoading
    @track phonenumbers = [];

    /* close the modal */
    closeAction() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    /* lifecycle hook fires when a component is inserted into the DOM. */
    connectedCallback() {

    }

    /*Use it to perform logic after a component has finished the rendering phase.
    * Calling APEX to get the Phone numbers to display on quick action dropdown
    */
    renderedCallback() {
        if (!this.completedLoading && this.recordId) {
            getPhoneNumbers({
                sobjectName: this.objectApiName,
                recordId: this.recordId
            }).then(data => {
                for (var key in data) {
                    this.phonenumbers.push({ label: key, value: data[key] }); // Setting Up Phone number options for combobox. 
                }
                this.completedLoading = true;

            }).catch(error => {
                console.log('error++' + error);
            });

        }
    }

    /* 
        *   This method is used to validate requiredfields and 
        * Call the Apex function to call sms send API
        */
    sendAction() {
        if (this.isInputValid()) {

            // Invoke Send SMS method and 
            //Passing 'Custom metadata developer Name( to get sender phone)', 'Recipient', 'Message Body'.            
            sendSMS({
                serviceName: this.objectApiName,
                sendTo: this.template.querySelector(".sendto").value,
                body: this.template.querySelector(".body").value,
                recordId: this.recordId
            }).then(result => {
                var smsresponse = JSON.parse(result);
                console.log('smsresponse.sid++' + smsresponse.sid);

                this.closeAction();
                if (smsresponse.sid) {

                    //Success Toast message
                    const event = new ShowToastEvent({
                        title: 'SMS',
                        message: 'SMS send successfully.',
                        variant: 'success'
                    });
                    this.dispatchEvent(event);
                } else {
                    // if SMS send is failed , display Error Toast message.
                    const event = new ShowToastEvent({
                        title: 'SMS Failed',
                        message: smsresponse.message,
                        variant: 'error'
                    });
                    this.dispatchEvent(event);
                }

            })
                .catch(error => {
                    // if any unexpected error , display Error Toast message.
                    console.log('Error ' + JSON.stringify(error));
                    const event = new ShowToastEvent({
                        title: 'Error',
                        message: 'Error sending SMS. Please Contact System Admin' + error,
                        variant: 'error'
                    });
                    this.dispatchEvent(event);
                });
        }
    }



    /* 
    *   This method is used to check 'TO:' and 'Body' input fields are populated or not
    *   it Returns Boolean value
    */
    isInputValid() {
        let isValid = true;
        if (!this.template.querySelector(".body").checkValidity()) {
            isValid = false;
            this.template.querySelector(".body").reportValidity();

        } else if (!this.template.querySelector(".sendto").checkValidity()) {
            isValid = false;
            this.template.querySelector(".sendto").reportValidity();
        }
        return isValid;
    }

}