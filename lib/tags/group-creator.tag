<graphjs-group-creator class="graphjs-root box">
    <div class="header">
        <div class="title">{opts.title || 'Create Group'}</div>
        <a class="option right" onclick={handleOverlay}>
            <svg viewBox="0 0 30 30" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
                <g transform="translate(-755.000000, -15.000000)" fill="black" fill-rule="nonzero">
                    <path d="M768.138179,30.0276818 L763.8,25.6895028 L765.689503,23.8 L770.011119,28.1447263 L774.332735,23.8 L776.222238,25.6895028 L771.884059,30.0276818 L771.888398,30.0320442 L771.884064,30.0363784 L776.222238,34.3414365 L774.332735,36.2309392 L770.011119,31.9093232 L765.689503,36.2309392 L763.8,34.3414365 L768.138174,30.0363784 L768.13384,30.0320442 L768.138179,30.0276818 Z M769.983425,15 C778.270718,15 785,21.6961326 785,29.9834254 C785,38.2707182 778.270718,45 769.983425,45 C761.696133,45 755,38.2707182 755,29.9834254 C755,21.6961326 761.696133,15 769.983425,15 Z M769.983425,42.3480663 C776.779006,42.3480663 782.348066,36.8121547 782.348066,29.9834254 C782.348066,23.1878453 776.812155,17.6187845 769.983425,17.6187845 C763.187845,17.6187845 757.618785,23.1546961 757.618785,29.9834254 C757.651934,36.7790055 763.187845,42.3480663 769.983425,42.3480663 Z"></path>
                </g>
            </svg>
        </a>
    </div>
    <div class="warning" if={failMessages.length > 0 || successMessages.length > 0}>
        <ul if={failMessages.length > 0} class="fail">
            <li each={failMessage in failMessages}>{failMessage}</li>
        </ul>
        <ul if={successMessages.length > 0} class="success">
            <li each={successMessage in successMessages}>{successMessage}</li>
        </ul>
    </div>
    <div class="content">
        <form>
            <input ref="title" type="text" placeholder="Enter group title" />
            <input ref="description" type="text" placeholder="Describe your group" />
            <button ref="submit" onclick={handleSubmit}>Create Group</button>
        </form>
    </div>
    <style type="less">
        @import '../styles/variables.less';
        @import '../styles/mixins.less';
        @import '../styles/options.less';
        @import '../styles/components/group-creator.less';
    </style>
    <script>
        import createGroup from '../scripts/createGroup.js';
        import showGroup from '../scripts/showGroup.js';
        import hideOverlay from '../scripts/hideOverlay.js';
        import showAlert from '../scripts/showAlert.js';
        import '../vendor/cloudinary/upload-widget.js';

        this.id = opts.id;
        this.failMessages = [];
        this.successMessages = [];

        this.checkTitleMinimumLength = () => {
            let titleMinimumLengthLimit = 2;
            let failMessage = 'Title must be ' + titleMinimumLengthLimit + ' characters minimum!';
            if(this.refs.title.value.length >= titleMinimumLengthLimit) {
                this.refs.title.classList.remove('error');
                this.failMessages.includes(failMessage) && this.failMessages.splice(this.failMessages.indexOf(failMessage), 1);
                return true;
            } else {
                this.refs.title.classList.add('error');
                this.failMessages.includes(failMessage) || this.failMessages.push(failMessage);
                return false;
            }
        }
        this.checkTitleMaximumLength = () => {
            let titleMaximumLengthLimit = 80;
            let failMessage = 'Title must be ' + titleMaximumLengthLimit + ' characters maximum!';
            if(this.refs.title.value.length <= titleMaximumLengthLimit) {
                this.refs.title.classList.remove('error');
                this.failMessages.includes(failMessage) && this.failMessages.splice(this.failMessages.indexOf(failMessage), 1);
                return true;
            } else {
                this.refs.title.classList.add('error');
                this.failMessages.includes(failMessage) || this.failMessages.push(failMessage);
                return false;
            }
        }
        this.checkDescriptionMinimumLength = () => {
            let descriptionMinimumLengthLimit = 10;
            let failMessage = 'Description must be ' + descriptionMinimumLengthLimit + ' characters minimum!';
            if(this.refs.description.value.length >= descriptionMinimumLengthLimit) {
                this.refs.description.classList.remove('error');
                this.failMessages.includes(failMessage) && this.failMessages.splice(this.failMessages.indexOf(failMessage), 1);
                return true;
            } else {
                this.refs.description.classList.add('error');
                this.failMessages.includes(failMessage) || this.failMessages.push(failMessage);
                return false;
            }
        }
        this.checkDescriptionMaximumLength = () => {
            let descriptionMaximumLengthLimit = 255;
            let failMessage = 'Description must be ' + descriptionMaximumLengthLimit + ' characters maximum!';
            if(this.refs.description.value.length <= descriptionMaximumLengthLimit) {
                this.refs.description.classList.remove('error');
                this.failMessages.includes(failMessage) && this.failMessages.splice(this.failMessages.indexOf(failMessage), 1);
                return true;
            } else {
                this.refs.description.classList.add('error');
                this.failMessages.includes(failMessage) || this.failMessages.push(failMessage);
                return false;
            }
        }
        this.validateInformation = () => {
            let validTitleMinimumLength = this.checkTitleMinimumLength();
            let validTitleMaximumLength = this.checkTitleMaximumLength();
            let validDescriptionMinimumLength = this.checkDescriptionMinimumLength();
            let validDescriptionMaximumLength = this.checkDescriptionMaximumLength();
            if(
                validTitleMinimumLength && validTitleMaximumLength && // Title
                validDescriptionMinimumLength && validDescriptionMaximumLength // Description
            ) {
                return true;
            } else {
                this.refs.submit.classList.remove('loading');
                return false;
            }
        }
        this.handleSubmit = (event) => {
            event.preventDefault();
            let self = this;
            self.refs.submit.classList.add('loading');
            let title = self.refs.title.value;
            let description = self.refs.description.value;
            self.refs.title.className = '';
            self.refs.description.className = '';
            self.failMessages = [];
            self.successMessages = [];
        	if(self.validateInformation()) {
                createGroup(
                    title,
                    description,
                    function(response) {
                        let failMessage = 'Group couldn\'t be created.';
                        let successMessage = 'Group has been created successfully.';
                        if(response.success) {
                            self.refs.title.classList.remove('error');
                            self.refs.title.classList.add('success');
                            self.refs.description.classList.remove('error');
                            self.refs.description.classList.add('success');
                            self.failMessages.includes(failMessage) && self.failMessages.splice(self.failMessages.indexOf(failMessage), 1);
                            self.successMessages.includes(successMessage) || self.successMessages.push(successMessage);
                            self.refs.submit.classList.remove('loading');
                            self.update();
                            showGroup({
                                "id": response.id,
                                "default": "settings"
                            });
                        } else {
                            self.refs.title.classList.remove('success');
                            self.refs.title.classList.add('error');
                            self.refs.description.classList.remove('success');
                            self.refs.description.classList.add('error');
                            self.successMessages.includes(successMessage) && self.successMessages.splice(self.successMessages.indexOf(successMessage), 1);
                            self.failMessages.includes(failMessage) || self.failMessages.push(failMessage);
                            self.refs.submit.classList.remove('loading');
                            self.update();
                        }
                    }
                );
            }
        }
        this.handleOverlay = () => hideOverlay();
    </script>
</graphjs-group-creator>