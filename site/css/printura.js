var dumb = function() { }

function SelectCity()
 {
  $('cityselclick').style.display = 'none';
  $('cityselect').style.display = 'inline';

  return false;
 }

function GoCity(selector)
 {
  window.location.replace('http://' + selector.value + '.' + rootdomain + '/');
 }

function GotSelector(s)
 {
  s = s.responseText;
  s = s.split("\x0D\x0A");

  if (s.length == 0) return;
  if (!(target = $(s[0]))) return;

  target.length = 0;

  for (k = 1; k < s.length - 1; k++)
   {
    y = s[k].split("\<\.\>");

    o = new Option();
    o.text = y[1];
    o.value = y[0];
    target.options[target.length] = o;
   }

  if (target.onchange) target.onchange();
 }

function Selector(src, dest, kind)
 {
  target = $(dest);

  o = new Option();  
  o.text = '...';
  o.value = '0';

  target.length = 0;
  target.options[target.length] = o;

  new Ajax.Request('/selector.html',
                   {method: 'get',
                    parameters: 'src=' + escape(src) + 
                                '&dest=' + escape(dest) + 
                                '&kind=' + escape(kind) + 
                                '&value=' + escape($(src).value) + 
                                '&' + Math.random(),
                    onComplete: GotSelector});
 }

function Helper(id)
 {
  width = 250;
  height = 300;

  var left = Math.round((document.body.clientWidth - width) / 2);
  var top = Math.round((document.body.clientHeight - height) / 2);

  var win = window.open('/helper.html?id=' + id,
                        'printhelper', 
                        'toolbar=no,' +
                        'scrollbars=yes,' +
                        'status=no,' +
                        'height=' + height + ',' +
                        'width=' + width + ',' + 
                        'top=' + top + ',' +
                        'left=' + left);

  win.focus();

  return false;
 }

function ReloadCaptcha(id, url)
 {
  $(id).src = url + '&' + Math.random();

  return false;
 }

function OverKind(i)
 {
  $('k' + i).style.background = '#8A1111';
  $('kh' + i)._excolor = $('kh' + i).style.color;
  $('kh' + i).style.color = '#ffffff';
 }

function OutKind(i, c)
 {
  $('k' + i).style.background = c;
  $('kh' + i).style.color = $('kh' + i)._excolor;
 }

function ForumFocusTA()
 {
  $('ta').focus();
 }

function ForumReply(where)
 {
  var topc = where.parentNode;
  var replyform = $('replyform');

  replyform.parentNode.removeChild(replyform);
  topc.appendChild(replyform);

  where.style.display = 'none';

  if (prev_to_show)
   prev_to_show.style.display = 'block';

  prev_to_show = where;

  setTimeout('ForumFocusTA();', 50);

  $('replyto').value = where.id;

  return false;
 }

/* (c) design.ru */

function UnHide( eThis )
 {
  if (eThis.innerHTML.indexOf('close') > 0)
   {
    eThis.innerHTML = '<img src="/images/icon_open.gif" width=13 height=13 alt="" border=0>'
    eThis.parentNode.parentNode.parentNode.className = '';
   }
  else
   {
    eThis.innerHTML = '<img src="/images/icon_close.gif" width=13 height=13 alt="" border=0>'
    eThis.parentNode.parentNode.parentNode.className = 'cl';
   }

  return false;
 }
