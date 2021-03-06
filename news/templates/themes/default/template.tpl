<!-- INCLUDE header.tpl -->
<script type="text/javascript" src="./js/jquery.paulund_modal_box.js"></script>
<script type="text/javascript">
var base = 60;
pausesend = false;
var clocktimer,dateObj,dh,dm,ds,ms;
var readout = '';
var h = 1;
var m = 1;
var tm = 1;
var s = 0;
var ts = 0;
var ms = 0;
var show = true;
var init = 0;
var ii = 0;
var parselimit = 0;
var st = 0;
var limit,curhour,curmin,cursec;

function clearALL() {
	clearTimeout(clocktimer);
	h = 1;
	m = 1;
	tm = 1;
	s = 0;
	ts = 0;
	ms = 0;
	init = 0;
	show = true;
	readout = '00:00:00';
	var Elemetstags = document.getElementsByTagName('span');
	
	for(var i=0; i<Elemetstags.length; i++){
		if(Elemetstags[i].id == 'timer1') { readout = Elemetstags[i].firstChild.data; }
	}	
		
	document.getElementById("timer1").innerHTML = readout;
	ii = 0;
}

function startTIME() {

var cdateObj = new Date();
var t = (cdateObj.getTime() - dateObj.getTime())-(s*1000);

if(t>999) { s++; }

if(s>=(m*base)) {
	ts = 0;
	m++;
} else {
	ts = parseInt((ms/100)+s);
	if(ts>=base) { ts = ts-((m-1)*base); }
}

if(m>(h*base)) {
	tm = 1;
	h++;
} else {
	tm = parseInt((ms/100)+m);
	if(tm>=base) { tm = tm-((h-1)*base); }
}

if(ts>0) { 
	ds = ts; 
	if (ts<10) { ds = '0'+ts; }
} else { 
	ds = '00'; 
}

dm = tm-1;

if(dm>0) { 
	if(dm<10) { dm = '0'+dm; }
} 
else { dm = '00'; }
dh = h-1;
if(dh>0) { 
	if (dh<10) { dh = '0'+dh; }} 
	else { dh = '00'; }
	readout = dh + ':' + dm + ':' + ds;
	if (show == true) { document.getElementById("timer1").innerHTML = readout; }
	clocktimer = setTimeout("startTIME()",1);
}

function findTIME() {
	if (init == 0) {
		dateObj = new Date();
		startTIME();
		init = 1;
	} else {
		if(show == true) { show = false;} 
		else { show = true; }
	}
}

var DOM = (typeof(document.getElementById) != 'undefined');

function Check_action()
{
	if(document.forms[0].action.value == 0) { window.alert('${ALERT_SELECT_ACTION}'); }
}

function CheckAll_Activate(Element,Name)
{
	if(DOM){
		thisCheckBoxes = Element.parentNode.parentNode.parentNode.parentNode.getElementsByTagName('input');

		var m = 0;

		for(var i = 1; i < thisCheckBoxes.length; i++){
			if(thisCheckBoxes[i].name == Name){
				thisCheckBoxes[i].checked = Element.checked;
				if(thisCheckBoxes[i].checked == true) { m++; }
				if(thisCheckBoxes[i].checked == false) { m--; }
			}
		}

		if(m > 0) { document.getElementById("Apply_").disabled = false; }
		else { document.getElementById("Apply_").disabled = true;  }
	}
}

function Count_checked()
{
	var All = document.forms[0];
	var m = 0;

	for(var i = 0; i < All.elements.length; ++i){
		if(All.elements[i].checked) { m++; }
	}

	if(m > 0) { document.getElementById("Apply_").disabled = false; }
	else { document.getElementById("Apply_").disabled = true; }
}

function sendout()
{
	var m = 0;
	pausesend = false;

	var All = document.forms[0];
	for(var i = 0; i<All.elements.length; ++i){
		if(All.elements[i].checked) { m++; }
	}
	
	typesend = 1;
	completed = null;
	successful = 0;
	unsuccessful = 0;
	totalmail = 0;
	
	findTIME();
	
	if(m == 0) {
		saveResult('${ALERT_MALING_NOT_SELECTED}');
	}	
	else{
		if(show == false) document.getElementById("timer1").innerHTML = '00:00:00';
		
		document.getElementById("timer2").innerHTML = '00:00:00';
		document.getElementById('pausesendout').className = "pausesendout_active";
		document.getElementById('stopsendout').className = "stopsendout_active";
		document.getElementById('refreshemail').className = "refreshemail_noactive";
		document.getElementById('sendout').className = "sendout_noactive";
		document.getElementById('process').className = "showprocess";
		getcoutprocess();
		onlinelogprocess();
		process();
	}	
}

function refreshsend()
{
	pausesend = false;
	
	typesend = 2;
	completed = null;
	successful = 0;
	unsuccessful = 0;
	totalmail = 0;
	
	document.getElementById("timer2").innerHTML = '00:00:00';
	document.getElementById('process').className = "showprocess";
	document.getElementById('refreshemail').className = "refreshemail_noactive";
	document.getElementById('sendout').className = "sendout_noactive";	
	findTIME();
	getcoutprocess();
	onlinelogprocess();
	process();	
}

function stopsend(str)
{
	var oXmlHttp = createXMLHttp();
	var url = "./?task=process&status=" + str;
	oXmlHttp.open("GET", url, true);
	
	oXmlHttp.onreadystatechange = function(){
		if(oXmlHttp.readyState == 4){
			document.getElementById('pause').value = 1;
			pausesend = true;
			show = false;
			
			document.getElementById('process').className = "";
			document.getElementById('pausesendout').className = "pausesendout_noactive";
			document.getElementById('stopsendout').className = "stopsendout_noactive";
			document.getElementById('sendout').className = "sendout_active";
			document.getElementById('refreshemail').className = "refreshemail_noactive";
			
			if(str == 'stop'){
				document.getElementById("timer2").innerHTML = '00:00:00';
				clearALL();
			}
		
			if(oXmlHttp.status == 200){
				if(oXmlHttp.responseXML.getElementsByTagName("process")[0].firstChild.data == 'stop') { window.location="./"; }
			}
			else{
				saveResult("${ALERT_ERROR_SERVER}: " + oXmlHttp.statusText);
			}
		}	
	};		
		
	oXmlHttp.send(null);	
}

function createXMLHttp() {
	var oXmlHttp = null;
    if (window.XMLHttpRequest) {
        oXmlHttp = new XMLHttpRequest();
    }
    else {
        var arrProgIds = ["Msxml2.XMLHTTP", "Microsoft.XMLHTTP"];
        for (var iCount = 0; iCount < arrProgIds.length; iCount++) {
            try {
                oXmlHttp = new ActiveXObject(arrProgIds[iCount]);
                break;
            }
            catch (e) { }
        }
    }
    return oXmlHttp;
}

function getcoutprocess()
{
	var oXmlHttp = createXMLHttp();
	
	if(pausesend == false && completed === null){
		var url = "./?task=xmlcountsend&id_log=" + id_log;
		oXmlHttp.open("POST",url, true);
		oXmlHttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        
		oXmlHttp.onreadystatechange = function() {
			if(oXmlHttp.readyState == 4) {
				if(oXmlHttp.status == 200) {
					if(id_log != undefined){						
						var totalmail = oXmlHttp.responseXML.getElementsByTagName("total")[0].firstChild.data;
						var successful = oXmlHttp.responseXML.getElementsByTagName("success")[0].firstChild.data;
						var unsuccessful = oXmlHttp.responseXML.getElementsByTagName("unsuccessful")[0].firstChild.data;
						var timeleft = oXmlHttp.responseXML.getElementsByTagName("time")[0].firstChild.data;

						document.getElementById("totalsendlog").innerHTML = totalmail;
						document.getElementById("unsuccessful").innerHTML = unsuccessful;
						document.getElementById("successful").innerHTML = successful;
						document.getElementById("timer2").innerHTML = timeleft;
						onlinelogprocess();
						setTimeout('getcoutprocess(id_log)', 2000);
					} else { setTimeout('getcoutprocess()', 1000); }						
				} else { setTimeout('getcoutprocess(id_log)', 3000); }
			}			
		};
        
		oXmlHttp.send(null);
				
	}	
}

function onlinelogprocess()
{
	if(pausesend == false){
		if(completed === null){	
			var oXmlHttp = createXMLHttp();
			var url = "./?task=xmllogonline";
			oXmlHttp.open("GET", url, true);
		
			oXmlHttp.onreadystatechange = function() {
				if(oXmlHttp.readyState == 4) {
					if(oXmlHttp.status == 200) {					
						var msg = '';					
						var emails = oXmlHttp.responseXML.getElementsByTagName("emails");			
						var status;
						var email;
						
						id_log = emails[0].getElementsByTagName("id_log")[0].firstChild.data;
				
						for(var i = 0; i<emails.length; i++){
							if(emails[i].getElementsByTagName("status")[0].firstChild.data == "yes"){ status = '${STR_SENT}'; }	
							else{ status = '${STR_WASNT_SENT}';	}	
							email = emails[i].getElementsByTagName("email")[0].firstChild.data;									

							if(email != 'undefined'){
								msg += email + ' - ' + status;
								msg += '<br>';
							}
						}
						
						document.getElementById("onlinelog").innerHTML = msg;
						//setTimeout('onlinelogprocess()', 2000);
					}
					else { saveResult("${ALERT_ERROR_SERVER}: " + oXmlHttp.statusText); }
				}
			};
		
			oXmlHttp.send(null);		
		}
	}	
}

function process()
{
	var oForm = document.forms[0];
	var sBody = getRequestBody(oForm);
	
	if(pausesend == false){
		var oXmlHttp = createXMLHttp();
		
		if(typesend == 1){
			var url = "./?task=send&typesend=1";
		}	
		else{ 
			var url = "./?task=send&typesend=2";
		}
		
		oXmlHttp.open("POST", url, true);	
		oXmlHttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
		
		oXmlHttp.onreadystatechange = function() {
			if(oXmlHttp.readyState == 4) {
				if(oXmlHttp.status == 200){		
					completed = oXmlHttp.responseXML.getElementsByTagName("completed")[0].firstChild.data;
					document.getElementById('process').className = "";
					completeProcess();
				}	
				else{
					setTimeout('process()', 3000);	
				}
			}
		};
		
		oXmlHttp.send(sBody);
	}
}

function completeProcess()
{
	document.getElementById('pausesendout').className = "pausesendout_noactive";
	document.getElementById('stopsendout').className = "stopsendout_noactive";
	document.getElementById('sendout').className = "sendout_active";
	document.getElementById('refreshemail').className = "refreshemail_active";
	document.getElementById('process').className = "";
	document.getElementById("timer2").innerHTML = '00:00:00';
	show = false;
	clearALL();
	getcoutprocess();
}


function saveResult(sText){
	var sElem = document.getElementById("divStatus");
	sElem.innerHTML = sText;
}

function getRequestBody(oForm) {
	var aParams = new Array();
	
	for(var i = 0; i < oForm.elements.length; i++) {
		var sParam = encodeURIComponent(oForm.elements[i].name);
	
		if(sParam != ''){
			if(oForm.elements[i].name == 'activate[]'){
				if(oForm.elements[i].checked){
					var sParam = encodeURIComponent(oForm.elements[i].name);
					sParam += "=";
					sParam += encodeURIComponent(oForm.elements[i].value);
				}			
			}
			else{	
				var sParam = encodeURIComponent(oForm.elements[i].name);
				sParam += "=";
				sParam += encodeURIComponent(oForm.elements[i].value);			
			}
		
			aParams.push(sParam);
		}		
	}	

	return aParams.join("&");
}

</script>

<!-- IF '${INFO_ALERT}' != '' -->
<div class="alert alert-info">
${INFO_ALERT}
</div>
<!-- END IF -->

<!-- IF '${ERROR_ALERT}' != '' -->
<div class="alert alert-error">
  <button class="close" data-dismiss="alert">×</button>
  <strong>${STR_ERROR}!</strong> ${ERROR_ALERT} </div>
<!-- END IF -->
<form action="${PHP_SELF}" onSubmit="if(document.forms[0].action.value == 0){window.alert('${ALERT_SELECT_ACTION}');return false;}if(document.forms[0].action.value == 4){return confirm('${ALERT_CONFIRM_REMOVE}');} if(document.forms[0].action.value == 1) return false" method="post">
  <table class="table-hover table table-bordered" border="0" cellspacing="0" cellpadding="0" width="100%">
    <thead>
      <tr>
        <th style="text-align: center;"><input type="checkbox" title="TABLECOLMN_CHECK_ALLBOX" onclick="CheckAll_Activate(this,'activate[]');"></th>
        <th width="50%">${TH_TABLE_MAILER}</th>
        <th>${TH_TABLE_CATEGORY}</th>
        <th>${TH_TABLE_ACTIVITY}</th>
        <th>${TH_TABLE_POSITION}</th>
        <th>${TH_TABLE_EDIT}</th>
      </tr>
    </thead>
    <!-- BEGIN row -->
    <tbody>
      <!-- BEGIN column -->
      <tr class="td-middle${CLASS_NOACTIVE}">
        <td><input type="checkbox" onclick="Count_checked();" title="${TABLECOLMN_CHECKBOX}" value="${ROW_ID_TEMPLATE}" name=activate[]></td>
        <td style="text-align: left;"><a title="${STR_EDIT_MAILINGTEXT}" href="./?task=edit_template&id_template=${ROW_ID_TEMPLATE}">${ROW_TMPLNAME}</a><br>
          <br>
          ${ROW_CONTENT}
          </div></td>
        <td>${ROW_CATNAME}</td>
        <td>${ROW_ACTIVE}</td>
        <td><p><a href="./?id_template=${ROW_ID_TEMPLATE}&pos=up" class="btn" title="${STR_DOWN}"><i class="icon-arrow-up"></i></a>
          <p>
          <p><a href="./?id_template=${ROW_ID_TEMPLATE}&pos=down" class="btn" title="${STR_DOWN}"><i class="icon-arrow-down"></i></a></p></td>
        <td><a href="./?task=edit_template&id_template=${ROW_ID_TEMPLATE}" class="btn" title="${STR_EDIT}"><i class="icon-pencil"></i></a></td>
      </tr>
      <!-- END column -->
      <!-- END row -->
    </tbody>
  </table>
  <div class="form-inline">
    <div class="control-group">
      <select id="select_action" class="span3 form-control" name="action">
        <option value="0">--${STR_ACTION}--</option>
        <option value="1">${STR_SENDOUT}</option>
        <option value="2">${STR_ACTIVATE}</option>
        <option value="3">${STR_DEACTIVATE}</option>
        <option value="4">${STR_REMOVE}</option>
      </select>
      <span class="help-inline">
      <input type="submit" id="Apply_" value="${STR_APPLY}" class="btn btn-success" disabled="" name="">
      </span> </div>
  </div>
</form>
<script type="text/javascript">
$('#select_action').click(function(e){
    var valOp = $('option:selected', this).index();
	
	if(valOp == 1){
		$(document).ready(function(){
			var modalform1 = '<span id="onlinelog"></span>';
			modalform1 += '<h4>${STR_TIME}</h4>';
			modalform1 += '<input id="pause" type="hidden" value="0">';
			modalform1 += '<input id="id_log" type="hidden" value="0">';
			modalform1 += '<input id="lefttime" type="hidden" value="00:00:00">';
			modalform1 += '${STR_TIME_PASSED}: <span id="timer1">00:00:00</span> ';
			modalform1 += '${STR_TIME_LEFT}: <span id="timer2">00:00:00</span>';
			modalform1 += '<div class="online_statistics">${STR_TOTAL}: <span id="totalsendlog">0</span> ';
			modalform1 += '<span style="color: green">${STR_GOOD}: </span><span style="color: green" id="successful">0</span> <span style="color: red">${STR_BAD}: </span><span style="color: red" id="unsuccessful">0</span><br><br>';
			modalform1 += '<span onClick="sendout();" id="sendout" title="${STR_SENDOUT_TO_SUBSCRIBERS}" class="sendout_active"></span>';
			modalform1 += '<span onClick="stopsend(\'pause\');" id="pausesendout" title="${STR_PAUSE_SENDING}" class="pausesendout_noactive"></span>';
			modalform1 += '<span onClick="refreshsend();" id="refreshemail" title="${STR_REFRESH_SENDING}" class="refreshemail_noactive"></span>';
			modalform1 += '<span onClick="stopsend(\'stop\');" id="stopsendout" title="${STR_STOP_SENDING}" class="stopsendout_noactive"></span></div>';
			modalform1 += '<span id="divStatus" class="error"></span>';
		
			$('#Apply_').paulund_modal_box({
				title:'${STR_ONLINE_MAILINGLOG}',
				description: modalform1
			});	
		});
	}
});
</script>
<!-- BEGIN pagination -->
<div class="pagination">
  <ul>
    <!-- IF '${PERVPAGE}' != '' -->
    <li>${PERVPAGE}</li>
    <!-- END IF -->
    <!-- IF '${PERV}' != '' -->
    <li>${PERV}</li>
    <!-- END IF -->
    <!-- IF '${PAGE2LEFT}' != '' -->
    <li>${PAGE2LEFT}</li>
    <!-- END IF -->
    <!-- IF '${PAGE1LEFT}' != '' -->
    <li>${PAGE1LEFT}</li>
    <!-- END IF -->
    <!-- IF '${CURRENT_PAGE}' != '' -->
    <li class="prev disabled">${CURRENT_PAGE}</li>
    <!-- END IF -->
    <!-- IF '${PAGE1RIGHT}' != '' -->
    <li>${PAGE1RIGHT}</li>
    <!-- END IF -->
    <!-- IF '${PAGE2RIGHT}' != '' -->
    <li>${PAGE2RIGHT}</li>
    <!-- END IF -->
    <!-- IF '${NEXTPAGE}' != '' -->
    <li>${NEXTPAGE}</li>
    <!-- END IF -->
    <!-- IF '${NEXT}' != '' -->
    <li>${NEXT}</li>
    <!-- END IF -->
  </ul>
</div>
<!-- END pagination -->
<!-- INCLUDE footer.tpl -->