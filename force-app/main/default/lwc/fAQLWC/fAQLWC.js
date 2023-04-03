import { LightningElement, wire, track } from 'lwc';
import loadFAQ from '@salesforce/apex/FAQController.loadFAQ';

export default class FAQLWC extends LightningElement {
    @track faqs = [];
    @track searchTerm = '';
    @track pageNumber = 1;
    @track hasMore = false;
    timer;
    pageSize = 2;

    @wire(loadFAQ, {pageNumber: '$pageNumber', pageSize: '$pageSize', searchTerm: '$searchTerm'})
    wiredFAQ({error, data}){
        if(data){
            this.faqs = this.faqs.concat(JSON.parse(data.ResponseJSON));
            this.hasMore = JSON.parse(data.ResponseJSON).length === this.pageSize;
        }
    }

    handleSearch(event){
        const searchTerm = event.target.value.toLowerCase();

        if(this.timer){
            clearTimeout(this.timer);
        }

        this.timer = setTimeout(() => {
            this.searchItems(searchTerm);
        }, 1000);
    }

    handleLoadMore(){
        this.pageNumber++;
    }

    searchItems(searchTerm){
        this.faqs = [];
        this.searchTerm = searchTerm;
        this.pageNumber = 1;
        this.hasMore = false;
    }
}
