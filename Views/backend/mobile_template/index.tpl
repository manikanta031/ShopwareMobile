{extends file="backend/index/parent.tpl"}

{block name="backend_index_body_inline"}
<link rel="stylesheet" media="screen, projection" href="{link file='backend/mobile_template/uploader/fileuploadfield.css'}" />
{literal}
<style type="text/css">
*:focus { outline: none }
.pnl { font: 11px/normal Verdana, sans-serif; }
.error, .notice, .success {padding:.8em;margin-bottom:1em;border:2px solid #ddd;}
.error, .instyle_error, input.instyle_error {background:#FBE3E4;color:#8a1f11;border-color:#FBC2C4;}
.notice {background:#FFF6BF;color:#514721;border-color:#FFD324;}
.success, .instyle_success {background:#E6EFC2;color:#264409;border-color:#C6D880;}
.error a {color:#8a1f11;}
.notice a {color:#514721;}
.success a {color:#264409;}
strong { font-weight: 700 }
.swag_notice .x-panel-body-noheader { border: 0 none }
#iphonePreview .x-panel-body .preview img {
	width: 198px;
	height: 372px;
	margin: 0 auto;
	display: block;
}
#iphonePreview .x-panel-body { padding: 15px; }
#iphonePreview .x-panel-body h3 {
	font: 700 14px tahoma,arial,helvetica,sans-serif; margin: 0 0 1em;
} 
p.desc, .native_teaser { font: 12px tahoma,arial,helvetica,sans-serif; margin: 0 0 1em; }
.native_teaser {
	background: url({/literal}{link file='backend/mobile_template/img/pic_step3.jpg'}{literal}) no-repeat right bottom;
	min-height: 124px;
	padding-right: 344px;
}
.native_teaser p, .native_teaser h2 { margin: 0 0 1em }
.screens { overflow: hidden; width: {/literal}{$screenshots|@count * 190}{literal}px; height: 276px; background: #efefef; }
.screens img {
	height: 230px;
	width: 160px;
	display: block;
	float: left;
	-webkit-box-shadow: 0 0 8px #111;
	-moz-box-shadow: 0 0 8px #111;
	margin: 15px;
}
#screensPnl { border: 1px solid #c7c7c7; }
#screensPnl .x-panel-body {
	overflow-x: scroll;
	background: #F7F7F7;
}

</style>
{/literal}
<script type="text/javascript" src="{link file='backend/mobile_template/uploader/FileUploadField.js'}"></script>
<script type="text/javascript">
Ext.ns('Shopware.SwagMobileTemplate');

(function() {
	Ext.QuickTips.init();
	View = Ext.extend(Ext.Viewport, {
	    layout: 'border',
	    initComponent: function() {
			var me = this;
			
			/** General settings form panel */
			this.generellPnl = new Ext.FormPanel({
				title: 'Grundkonfiguration',
				padding: 15,
				autoScroll: true,
				items: [{
					xtype: 'fieldset',
					anchor: '0',
					title: 'Grundkonfiguration',
					labelWidth: 250,
					items: [{
						// Supported devices
						xtype: 'checkboxgroup',
						fieldLabel: 'Unterst&uuml;tzte Ger&auml;te',
						name: 'supportedDevices',
						columns: 2,
						items: {$supportedDevicesJSON}
					}, {
						// Supported Paymentmeans
						xtype: 'checkboxgroup',
						fieldLabel: 'Unterst&uuml;tzte Zahlungsarten',
						name: 'supportedPaymentmeans',
						columns: 2,
						items: {$supportedPaymentmeansJSON}
					}, {
						// Shopsite ID AGB
						xtype: 'textfield',
						fieldLabel: 'Shopseiten-ID zu den AGB',
						width: 200,
						name: 'agbInfoID',
						value: '{$agbInfoID}'
					}, {
						// Shopsite ID Right of Cancelation
						xtype: 'textfield',
						fieldLabel: 'Shopseiten-ID zum Wiederrufsrecht',
						name: 'cancelRightID',
						width: 200,
						value: '{$cancelRightID}'
					}, {
						// Shopsite group name
						xtype: 'textfield',
						fieldLabel: 'Shopseiten-Gruppe',
						name: 'infoGroupName',
						width: 200,
						value: '{$infoGroupName}'
					}, {
						// Show Link to normal version of the shop
						xtype: 'checkbox',
						fieldLabel: 'Link zur normalen Ansicht',
						name: 'showNormalVersionLink',
						checked: {if $showNormalVersionLink}true{else}false{/if}
					}, {
						// Voucher on confirm page
						xtype: 'checkbox',
						fieldLabel: 'Gutscheineingabe auf der Bestellbest&auml;tigungsseite anzeigen',
						name: 'useVoucher',
						checked: {if $useVoucher}true{else}false{/if}
					}, {
						// Newsletter signup on confirm page
						xtype: 'checkbox',
						fieldLabel: 'Newsletter-Anmeldung auf der Bestellbest&auml;tigungsseite anzeigen',
						name: 'useNewsletter',
						checked: {if $useNewsletter}true{else}false{/if}
					}, {
						// Commentfield on confirm page
						xtype: 'checkbox',
						fieldLabel: 'Kommentarfeld auf der Bestellbest&auml;tigungsseite anzeigen',
						name: 'useComment',
						checked: {if $useComment}true{else}false{/if}
					}],
					buttons: [{
			        	text: 'Allgemeine Anpassungen speichern',
			        	name: 'saveGenerell',
			        	scope: this,
			        	handler: function() {
			        		this.generellPnl.getForm().submit({
			        			url: '{url controller="MobileTemplate" action="processGenerellForm"}',
			        			waitMsg: 'Sende Daten...',
			        			success: function(form, response) {
			        				Ext.Msg.show({
			        					title: 'Speichern erfolgreich',
			        					msg: response.result.message,
			        					buttons: Ext.Msg.OK,
			        					icon: Ext.MessageBox.INFO
			        				});
			        			},
			        			failure: function(form, response) {
			        				Ext.Msg.show({
			        					title: 'Es ist ein Fehler aufgetreten',
			        					msg: response.result.message,
			        					buttons: Ext.Msg.OK,
			        					icon: Ext.MessageBox.ERROR
			        				});
			        			}
			        		})
			        	}
			        }]
				}, {
					xtype: 'fieldset',
					title: 'Subshop-Anpassungen',
					labelWidth: 250,
					items: [{
						// Use Shopware Mobile as a subshop
						xtype: 'checkbox',
						fieldLabel: 'Shopware Mobile als Subshop verwenden',
						name: 'useAsSubshop',
						checked: {if $useAsSubshop}true{else}false{/if}
					}, {
						// Subshop ID
						xtype: 'textfield',
						fieldLabel: 'Subshop-ID',
						name: 'subshopID',
						width: 200,
						value: '{$subshopID}'
					}],
					buttons: [{
			        	text: 'Subshop Anpassungen speichern',
			        	scope: this,
			        	handler: function() {
			        		this.generellPnl.getForm().submit({
			        			url: '{url controller="MobileTemplate" action="processGenerellForm"}',
			        			waitMsg: 'Sende Daten...',
			        			success: function(form, response) {
			        				Ext.Msg.show({
			        					title: 'Speichern erfolgreich',
			        					msg: response.result.message,
			        					buttons: Ext.Msg.OK,
			        					icon: Ext.MessageBox.INFO
			        				});
			        			},
			        			failure: function(form, response) {
			        				Ext.Msg.show({
			        					title: 'Es ist ein Fehler aufgetreten',
			        					msg: response.result.message,
			        					buttons: Ext.Msg.OK,
			        					icon: Ext.MessageBox.ERROR
			        				});
			        			}
			        		})
			        	}
			        }]
				}]
			});
			
			
			this.colorTemplateStore = new Ext.data.JsonStore({
				autoLoad: true,
				url: '{url controller="MobileTemplate" action="getColorTemplateStore"}',
				storeId: 'colorTemplateStore',
				root: 'data',
				idProperty: 'id',
				successProperty: 'success',
				totalProperty: 'totalCount',
				fields: [ 'id', 'value', 'displayText', 'previewImage' ],
				valueField: 'value',
				displayField: 'displayText'
			});
			
			this.statusbarStyleStore = new Ext.data.JsonStore({
				autoLoad: true,
				url: '{url controller="MobileTemplate" action="getStatusbarStyleStore"}',
				storeId: 'statusbarStyleStore',
				root: 'data',
				idProperty: 'id',
				successProperty: 'success',
				totalProperty: 'totalCount',
				fields: [ 'id', 'value', 'displayText' ],
				valueField: 'value',
				displayField: 'displayText'
			});
			
			/** Design related settings form panel */
			this.designFormPnl = new Ext.FormPanel({
				bodyBorder: false,
				id: 'designForm',
				labelWidth: 250,
				width: '70%',
				fileUpload: true,
				items: [{
					xtype: 'fieldset',
					title: 'Design-Anpassungen',
					items: [{
					
						// Checkboxes green
						xtype: 'checkbox',
						fieldLabel: 'AGB Hacken gr�n',
						name: 'checkboxesGreen',
						checked: {if $checkboxesGreen}true{else}false{/if}
					}, {

						// Sencha.io "Src"
						xtype: 'checkbox',
						fieldLabel: 'Sencha.io "Src" verwenden',
						name: 'useSenchaIO',
						checked: {if $useSenchaIO}true{else}false{/if}
					}, {
						// Colortemplate
			            fieldLabel: 'Farbtemplate',
			            xtype: 'combo',
			            mode: 'local',
			            triggerAction: 'all',
			            name: 'colorTemplate',
			            value: '{$colorTemplate}',
			            store: this.colorTemplateStore,
			            hiddenName: 'hiddenColorTemplate',
			            listeners: {
			            	scope: this,
			            	
			            	/** Change preview image on select */
			            	select: function(combo, rec, idx) {
			          		
			            		var previewImgPnl = Ext.getCmp('iphonePreview');
			            		var html = '<img src="'+ rec.data.previewImage +'" alt="Farbtemplate '+ rec.data.displayText +'" title="Farbtemplate '+ rec.data.displayText +'" />'
			            		
			            		previewImgPnl.body.update(html);
			            		previewImgPnl.doLayout();
			            		
			            	}
			            },
			            valueField: 'value',
   						displayField: 'displayText',
   						width: 300
			        }, {
			        	// Shoplogo - Uploadfield
			        	xtype: 'fileuploadfield',
			        	emptyText: '',
			        	fieldLabel: 'Shoplogo-Upload',
			        	buttonText: 'Logo ausw�hlen',
			        	name: 'logoUpload',
			        	width: 390,
			        	id: 'logoUpload',
			        	value: '{$logoUpload}'
			        }, {
			        	// Additional CSS settings
			        	xtype: 'textarea',
			        	fieldLabel: 'Zus�tzliche CSS-Eigenschaften',
			        	width: 300,
			        	height: 150,
			        	name: 'additionalCSS',
			        	value: '{$additionalCSS}'
			        }],
			        buttons: [{
			        	text: 'Design-Anpassungen speichern',
			        	scope: this,
			        	handler: function() {
			        		this.designFormPnl.getForm().submit({
			        			url: '{url controller="MobileTemplate" action="processDesignForm"}',
			        			waitMsg: 'Sende Daten...',
			        			success: function(form, response) {
			        				Ext.Msg.show({
			        					title: 'Speichern erfolgreich',
			        					msg: response.result.message,
			        					buttons: Ext.Msg.OK,
			        					icon: Ext.MessageBox.INFO
			        				});
			        			},
			        			failure: function(form, response) {
			        				Ext.Msg.show({
			        					title: 'Es ist ein Fehler aufgetreten',
			        					msg: response.result.message,
			        					buttons: Ext.Msg.OK,
			        					icon: Ext.MessageBox.ERROR
			        				});
			        			}
			        		})
			        	}
			        }]
				}, {
					xtype: 'fieldset',
					labelWidth: 250,
					title: 'iOS spezifische Anpassungen',
					items: [{
						// Notice for iOS devices only
						bodyBorder: false,
						html: '<p class="desc"><strong>Hinweis:</strong> Die hier gesetzten Einstellungen gelten nur f�r iOS-Ger�te wie dem iPhone, iPod touch und den iPad.</p>'
					}, {
						// Icon Upload
						xtype: 'fileuploadfield',
						emptyText: '',
						fieldLabel: 'Homescreen-Icon Upload',
						buttonText: 'Icon ausw�hlen',
						name: 'iconUpload',
						width: 390,
						id: 'iconUpload',
						value: '{$iconUpload}'
					}, {
						// Startup screen upload
						xtype: 'fileuploadfield',
						emptyText: '',
						fieldLabel: 'iOS Startupscreen Upload',
						buttonText: 'Screen ausw�hlen',
						name: 'startupUpload',
						width: 405,
						id: 'startupUpload',
						value: '{$startupUpload}'
					}, {
			        	// Statusbar style
			        	xtype: 'combo',
			        	mode: 'local',
			        	triggerAction: 'all',
			        	fieldLabel: 'Statusbar-Style',
			        	hiddenName: 'hiddenStatusbarStyle',
			        	hiddenValue: 'value',
			        	store: this.statusbarStyleStore,
			        	valueField: 'value',
						displayField: 'displayText',
   						name: 'statusbarStyle',
   						value: '{$statusbarStyle}',
   						width: 303
			        }, {
			        	// Gloss over icon
			        	xtype: 'checkbox',
			        	fieldLabel: 'Glanz �ber Icon anzeigen',
			        	name: 'glossOnIcon',
			        	checked: {if $glossOnIcon}true{else}false{/if}
			        }],
					buttons: [{
			        	text: 'iOS-Anpassungen speichern',
			        	scope: this,
			        	handler: function() {
			        		this.designFormPnl.getForm().submit({
			        			url: '{url controller="MobileTemplate" action="processDesignForm"}',
			        			waitMsg: 'Sende Daten...',
			        			success: function(form, response) {
			        				Ext.Msg.show({
			        					title: 'Speichern erfolgreich',
			        					msg: response.result.message,
			        					buttons: Ext.Msg.OK,
			        					icon: Ext.MessageBox.INFO
			        				});
			        			},
			        			failure: function(form, response) {
			        				Ext.Msg.show({
			        					title: 'Es ist ein Fehler aufgetreten',
			        					msg: response.result.message,
			        					buttons: Ext.Msg.OK,
			        					icon: Ext.MessageBox.ERROR
			        				});
			        			}
			        		})
			        	}
			        }]
				}]
			});
			
			this.designPreviewPnl = new Ext.TabPanel({
				activeTab: 0,
				bodyBorder: false,
				title: 'Vorschau',
				padding: 10
			});
			
			this.iphonePreview = new Ext.Panel({
				title: 'Farbtemplate',
				id: 'iphonePreview',
				height: 372,
				bodyBorder: false,
				html: '<img src="{$pluginBase|cat:$colorTemplate}.jpg" />'
			});
			this.designPreviewPnl.add(this.iphonePreview);
			
			{if $logoUpload}
				this.logoPreview = new Ext.Panel({
					title: 'Logo',
					id: 'logoPreview',
					bodyBorder: false,
					html: '<img src="{$logoUpload}" />'
				});
				this.designPreviewPnl.add(this.logoPreview);
			{/if}
			
			{if $iconUpload}
				this.iconPreview = new Ext.Panel({
					title: 'Icon',
					id: 'iconPreview',
					bodyBorder: false,
					html: '<img src="{$iconUpload}" />'
				});
				this.designPreviewPnl.add(this.iconPreview);
			{/if}
			
			{if $startupUpload}
				this.startupPreview = new Ext.Panel({
					title: 'Startup',
					id: 'startupPreview',
					bodyBorder: false,
					html: '<img src="{$startupUpload}" />'
				});
				this.designPreviewPnl.add(this.startupPreview);
			{/if}
			
			/** Container panel for the both design panels */
			this.designPnl = new Ext.Panel({
				layout: 'hbox',
				padding: 15,
				autoScroll: true,
				bodyBorder: false,
				title: 'Design-Anpassungen',
				items: [this.designFormPnl, this.designPreviewPnl]
			});
			
			this.nativeFieldSet = new Ext.form.FieldSet({
				title: 'Applikationseinstellungen',
				labelWidth: 250,
				
				width: '50%',
				items: [{
					// App name
					xtype: 'textfield',
					fieldLabel: 'Titel',
					allowBlank: false,
					name: 'apptitle',
					width: 250,
					value: '{$apptitle}'
				}, {
					// Version
					xtype: 'textfield',
					fieldLabel: 'Version',
					allowBlank: false,
					name: 'appversion',
					width: 250,
					value: '{$appversion}'
				}, {
					// Release date
					fieldLabel: 'Ver&ouml;ffentlichsdatum',
					xtype: 'datefield',
					allowBlank: false,
					width: 250,
					name: 'publish_date',
					value: '{$publishdate}'
				}, {
					// Keywords
					fieldLabel: 'Keywords',
					name: 'keywords',
					xtype: 'textfield',
					allowBlank: false,
					width: 250,
					value: '{$keywords}'
				}, {
					// Contact eMail Address
					xtype: 'textfield',
					allowBlank: false,
					width: 250,
					fieldLabel: 'Kontakt eMail Adresse',
					name: 'contact_email',
					value: '{$contact_email}'
				}, {
					// Support URL
					xtype: 'textfield',
					name: 'support_url',
					allowBlank: false,
					width: 250,
					fieldLabel: 'Support URL',
					value: '{$support_url}'
				}, {
					// App URL
					xtype: 'textfield',
					name: 'app_url',
					fieldLabel: 'App-URL (optional)',
					width: 250,
					value: '{$app_url}'
				}, {
					// Description
					xtype: 'textarea',
					fieldLabel: 'Beschreibung',
					width: 250,
					height: 175,
					name: 'description',
					allowBlank: false,
					value: '{$description}'
				}, {
					// Changelog
					xtype: 'textarea',
					fieldLabel: 'Changelog (falls �ltere Version verf�gbar)',
					width: 250,
					height: 175,
					name: 'changelog',
					allowBlank: true,
					value: '{$changelog}'
				}, {
					// iPhone Screenshots hochladen
					xtype: 'fileuploadfield',
					emptyText: '',
					fieldLabel: 'Screenshots Upload (Mehrfachauswahl)',
					buttonText: 'Screens ausw�hlen',
					name: 'screenshots[]',
					width: 250,
					multiple: true
				}]
			});
			
			this.holderPnl = new Ext.Panel({
				layout: 'hbox',
				bodyBorder: false,
				items: [this.nativeFieldSet]
			});
			
			/** Native application panel */
			this.nativePnl = new Ext.FormPanel({				
				padding: 15,
				autoScroll: true,
				fileUpload: true,
				disabled: true,
				title: 'Native Applikation einreichen',
				items: [{
					// Price information
					bodyBorder: false,
					cls: 'native_teaser',
					html: '<h2>Shopware Mobile - Native Applikation</h2><p>Shopware Mobile kann auch als native App bereitgestellt werden. So k�nnen Sie als Shopbetreiber die App Stores von Apple, Android und co. als zus�tzliches Marketinginstrument nutzen und sich dauerhaft auf den Smartphones Ihrer Kunden platzieren.</p><p>F�llen Sie hierzu das Formular "Applikationseinstellungen" aus und wir senden Ihnen eine Best�tigung, wenn die Applikation erfolgreich erstellt wurde.</p><p class="price"><strong>Einmalige Einrichtungsgeb&uuml;hr:</strong> <span>99,00 &euro;</span></p><p class="price"><strong>Monatliche Kosten:</strong> <span>79,00 &euro;</span></p>'

				}, this.holderPnl],
				buttons: [{
					text: 'Applikationseinstellungen speichern',
					scope: this,
		        	handler: function() {
		        		this.nativePnl.getForm().submit({
		        			url: '{url controller="MobileTemplate" action="processNativeApplicationForm"}',
		        			waitMsg: 'Sende Daten...',
		        			success: function(form, response) {
		        				Ext.Msg.show({
		        					title: 'Speichern erfolgreich',
		        					msg: response.result.message,
		        					buttons: Ext.Msg.OK,
		        					icon: Ext.MessageBox.INFO
		        				});
		        			},
		        			failure: function(form, response) {
		        				Ext.Msg.show({
		        					title: 'Es ist ein Fehler aufgetreten',
		        					msg: response.result.message,
		        					buttons: Ext.Msg.OK,
		        					icon: Ext.MessageBox.ERROR
		        				});
		        			}
		        		})
		        	}
				}, {
					text: 'Applikation einreichen',
					scope: this,
					disabled: true,
					handler: function() { alert('super ingo'); }
				}]
			});
			
			{if $screenshots}
				var htmlStr = '';
				{foreach $screenshots as $screen}
					htmlStr += '<img src="{$screen}" />';
				{/foreach}
			
				this.screenshots = new Ext.form.FieldSet({
					title: 'Screenshots',
					width: '49%',
					style: 'margin-left: 1%',
					items: [{
						xtype: 'panel',
						bodyBorder: false,
						height: 285,
						width: 420,
						id: 'screensPnl',
						html: '<div class="screens">'+htmlStr+'</div>'
					}]
				});
				this.holderPnl.add(this.screenshots);
			{/if}
			
			/** Main tabpanel navigation */
			this.tabPnl = new Ext.TabPanel({
				activeTab: 0,
				region: 'center',
				autoWidth: false,
				items: [this.generellPnl, this.designPnl, this.nativePnl]
			});
			
			/** Beta notice panel */
			this.betaNoticePnl = new Ext.Panel({
				plain: true,
				padding: 10,
				bodyBorder: false,
				cls: 'swag_notice',
				region: 'north',
				html: '<div class="error pnl"><strong>Hinweis:</strong> Dieses Plugin befindet sich zur Zeit im Beta-Status und ist daher nicht f�r den produktiven Einsatz geeignet.</div>'
			});
			
			this.items = [this.betaNoticePnl, this.tabPnl];
			
	    	View.superclass.initComponent.call(this);
	    }
	});
	Shopware.SwagMobileTemplate.View = View;
})();
Ext.onReady(function(){
	OurView = new Shopware.SwagMobileTemplate.View;
});
</script>
{/block}