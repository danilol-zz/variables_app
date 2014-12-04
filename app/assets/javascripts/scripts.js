$(document).ready(function(){

    /*****************************************************************/
    /***** Inicializador de funções *****/
    /*****************************************************************/
    checkFooter();
	$('[rel="tooltip-big"]').popover()
    $('[rel="tooltip-mini"]').tooltip();
    
    /*****************************************************************/
    /***** ABAS *****/
    /*****************************************************************/
    $('[data-tab]').on('click', function (e) {
        $(this)
            .addClass('ativo')
            .siblings('[data-tab]')
            .removeClass('ativo')
            .siblings('[data-content=' + $(this).data('tab') + ']')
            .addClass('ativo')
            .siblings('[data-content]')
            .removeClass('ativo');
        e.preventDefault();
    });


    /*****************************************************************/
    /***** jQuery Mask *****/
    /*****************************************************************/

    /* Datas */
    $('.mask-data').mask('00/00/0000');
    $('.mask-dia').mask('00');
    $('.mask-mes').mask('00');
    $('.mask-ano').mask('0000');
    $('.mask-tempo').mask('00:00:00');
    $('.mask-data_tempo').mask('00/00/0000 00:00:00');
    /* Telefones */
    $('.mask-fone').mask('0000-00000');
    $('.mask-ddd').mask('(00)');
    $('.mask-fone_ddd').mask('(00) 0000-00000');
    /* Endereços */
    $('.mask-cep').mask('00000-000');
    /* Documentos */
    $('.mask-cpf').mask('000.000.000-00', {reverse: true});
    $('.mask-rg').mask('00.000.000-A');
    /* Valores */
    $('.mask-valor').mask("#.##0,00", {reverse: true, maxlength: false});
    $('.mask-porcentagem').mask('##0,00%', {reverse: true});
    /* Diversos */
    $('.mask-ip').mask('0ZZ.0ZZ.0ZZ.0ZZ', {translation: {'Z': {pattern: /[0-9]/, optional: true}}});
  

    /*****************************************************************/
    /***** CONFIG MENU *****/
    /*****************************************************************/

    $('nav ul li.mnu').hover(function() {
        $(this).children('.sub-mnu').removeClass('hide');
    }, function() {
        $(this).children('.sub-mnu').addClass('hide');
    });

    $('.ico-configuracoes').click(function() {
        $('.content-config').toggleClass('hide');
    });

	/*****************************************************************/
	/***** DROPDOWN - Form *****/
    /* Atenção: MODELO ANTIGO - Utilizar apenas o modelo abaixo */
    /* Este modelo permanece aqui apenas para fins de convivência com páginas antigas já criadas */
	/*****************************************************************/
	
    /*
    $('.dropdown').click(function() {
		var height = $(this).parent().outerHeight(true,true);
		var top = $(this).parent().offset().top;

		if(!$(this).children('.dropdown_menu').is(":visible")){
			$('.dropdown_menu').stop(true, true).fadeOut(200);
			$(this).children('.dropdown_menu').stop(true, true).fadeIn(200);
			$(this).children('.dropdown_menu.adjustHeight').css({
				"height":height,
				"padding-right":"20px",
				"overflow-y":"auto",
				"overflow-x":"hidden"
			});
		}else{
			$('.dropdown_menu').stop(true, true).fadeOut(200);
		}
	});	
	
	$('.dropdown .dropdown_menu .opcao').click(function(){
		var selectedValue = $(this).text();
		var url = $(this).data('url');
		$(this).parent('.dropdown_menu').siblings('span').text(selectedValue);
		if(url){
			window.location.href = url;
		};
	});

    $(".seleciona-conteudo").click(function(e){
        e.preventDefault();
        var contSub = $(this).attr("data-aba");

        $(this).parents('.formulario').find('.drop-conteudo').addClass('hide');
        $(this).parents('.formulario').find('.drop-conteudo#'+ contSub +'').removeClass('hide');
    });
    */

    /*****************************************************************/
    /***** SELECTS - Form - MODELO NOVO / OK - Utilizar este! *****/
    /*****************************************************************/

    /*
    $('select').each(function() {
        var label = $(this).children('option:selected').text();
        $(this).css('opacity','0');
        $(this).wrap('<div class="fake-select" />');
        $(this).before('<span class="label">' + label + '</span>');
    });
    $('select').change(function() {
        var newLabel = $(this).children('option:selected').text();
        var $fakeSelect = $(this).parent('.fake-select');
        $fakeSelect.children('.label').text(newLabel);
    });

	$('#seleciona-autenticacao').change(function() {
        $('#content-chaveiro, #content-sms, #content-app').addClass('hide');
        $('#content-' + $(this).find('option:selected').attr('id')).removeClass('hide');
    });
    */


    /* Seleciona Período - Fatura de Cartão */
    $(function() {
    $('#seleciona-periodo').change(function(){
        /*alert('The option with value ' + $(this).val());*/
        if($('#seleciona-periodo').val() == 'Especifico') {
            $('#fatura-periodo-especifico').removeClass('hide'); 
        } else {
            $('#fatura-periodo-especifico').addClass('hide'); 
        } 
    });


    /*****************************************************************/
    /***** Consistência de Formulários *****/
    /*****************************************************************/
    $('.mensagem-erro').hide();

    $('.invalido').focus(function() {
       $('.mensagem-erro').hide();
       $("."+$(this).attr('validacao')).show();
    });

    $('.invalido').blur(function() {
       $('.mensagem-erro').hide();
    });

    $('.invalido').each(function(index,element){
        var newIndex = index+1;
        $(this).attr('validacao', 'campo' + newIndex);
    });    

    $('.mensagem-erro').each(function(index,element){
        var newIndex = index+1;
        $(this).addClass('campo' + newIndex);
    });

});

	/*****************************************************************/
	/***** ACCORDION - Abrir e Fechar elementos *****/
	/*****************************************************************/
	/* Accordeon Páginas Internas */
    $('section .flex').click(function() {
        $(this).parent('section').toggleClass('fechado');
        $(this).parent('section').toggleClass('aberto');
        $(this).siblings('section .conteudo').stop(true, true).slideToggle(200);
    }); // end Collapse - Internas

    /* Accordeon Home - Módulo Principal */
    $('.modulo h2.flex-home').click(function() {
        var texto = $(this).find("span").text();
        $(this).siblings('.conteudo').stop(true, true).slideToggle(200);
        $(this).parent().toggleClass('fechado').toggleClass('aberto');

        if(texto === "ocultar"){
            $(this).find("span").text("exibir");
        }else{
            $(this).find("span").text("ocultar");
        }
    }); // end Collapse - Home


    /* Accordeon Home - Sidebar */
    $('.modulo h4.flex-home').click(function() {
        $(this).parent('.modulo').toggleClass('fechado');
        $(this).parent('.modulo').toggleClass('aberto');
        $(this).siblings('.modulo .conteudo').stop(true, true).slideToggle(200);
    }); // end Collapse - Home Sidebar

	/*****************************************************************/
	/***** (x) Fechar Box Alerta *****/
	/*****************************************************************/
	$('.fechar').click(function(){
		$(this).parents('.box-info-alerta').fadeOut(300);
	}); // end Fechar Alerta
	$('.fechar').click(function(){
		$(this).parents('.box-info-comprovante').fadeOut(300);
	}); // end Fechar Alerta
	/*****************************************************************/
	/***** Lightbox - Magnific Popup *****/
	/*****************************************************************/
	$('.popup-with-form').magnificPopup({
      type: 'inline',
      preloader: false,
      focus: '#name',
      callbacks: {
        beforeOpen: function() {
          if($(window).width() < 700) {
            this.st.focus = false;
          } else {
            this.st.focus = '#name';
          }
        }
      }
    });
    /* Tradução de elementos - Magnific Popup */
    $.extend(true, $.magnificPopup.defaults, {
	  tClose: 'Fechar (Esc)',
	  tLoading: 'Carregando...',
	  gallery: {
	    tPrev: 'Anterior (Seta esquerda do teclado)',
	    tNext: 'Próximo (Seta direita do teclado)',
	    tCounter: '%curr% de %total%'
	  },
	  image: {
	    tError: '<a href="%url%">A imagem</a> não pode ser carregada.'
	  },
	  ajax: {
	    tError: '<a href="%url%">O conteúdo</a> não pode ser carregado.'
	  }
	});

	/*****************************************************************/
	/***** Contador de caracteres *****/
	/*****************************************************************/
	$(".maxlength").keyup(function(event){
		
        var target  = $("#char-counter");
        var max     = target.attr('maxchar');
        var len     = $(this).val().length;
        var remain  = max - len;
 
        if(len > max)
        {
        	var val = $(this).val();
            $(this).val(val.substr(0, max));
            remain = 0;
        }
        target.html(remain);
    }); // end Contador de Caracteres

    /*****************************************************************/
	/***** MÓDULOS DE AUTENTICAÇÃO *****/
	/*****************************************************************/

    /* Chaveiro */
    $("input#chaveiro-entraCodigo").keyup(function(e){
        var nextStep = $(this).attr("data-idnextstep");
            if(this.value == "" || this.value == this.defaultValue){
                $("#"+nextStep).addClass("desabilitado");
            }else{
                $("#"+nextStep).removeClass("desabilitado");
            }
    });
	$(".modulo-autenticacao .btn-fluxo#chaveiro-codigoOk").click(function(){
        if(!$(this).hasClass("desabilitado")){
            $("input#chaveiro-entraSenha").removeAttr("disabled");
            $("#escolheDispositivo").css("display","none");
            $("#chaveiro-codigoSeguranca").css("display","none");
            $("#chaveiro-codigoOk").css("display","none");
            $("#chaveiro-confirmacao").removeClass("hide");
        }
    });
    $("input#chaveiro-entraSenha").keyup(function(e){
        var nextStep = $(this).attr("data-idnextstep");
            if(this.value == "" || this.value == this.defaultValue){
                $("#"+nextStep).addClass("desabilitado");
            }else{
                $("#"+nextStep).removeClass("desabilitado");
            }
    });

    /* Aplicativo */
    $("input#app-entraCodigo").keyup(function(e){
        var nextStep = $(this).attr("data-idnextstep");
            if(this.value == "" || this.value == this.defaultValue){
                $("#"+nextStep).addClass("desabilitado");
            }else{
                $("#"+nextStep).removeClass("desabilitado");
            }
    });
    $(".modulo-autenticacao .btn-fluxo#app-codigoOk").click(function(){
        if(!$(this).hasClass("desabilitado")){
            $("input#app-entraSenha").removeAttr("disabled");
            $("#escolheDispositivo").css("display","none");
            $("#app-codigoSeguranca").css("display","none");
            $("#app-codigoOk").css("display","none");
            $("#app-confirmacao").removeClass("hide");
        }
    });
    $("input#app-entraSenha").keyup(function(e){
        var nextStep = $(this).attr("data-idnextstep");
            if(this.value == "" || this.value == this.defaultValue){
                $("#"+nextStep).addClass("desabilitado");
            }else{
                $("#"+nextStep).removeClass("desabilitado");
            }
    });

    /* SMS */
    $("input#sms-codigoRecebido").keyup(function(e){
        var nextStep = $(this).attr("data-idnextstep");
            if(this.value == "" || this.value == this.defaultValue){
                $("#"+nextStep).addClass("desabilitado");
            }else{
                $("#"+nextStep).removeClass("desabilitado");
            }
    });
    $(".modulo-autenticacao .btn-fluxo#sms-gerarCodigo").click(function(){
        if(!$(this).hasClass("desabilitado")){
            $("input#sms-codigoRecebido").removeAttr("disabled");
            $("#sms-mensagem").addClass("hide");
            $("#sms-confirmacao").removeClass("hide");
        }
    });
    $(".modulo-autenticacao .btn-fluxo#sms-codigoOk").click(function(){
        if(!$(this).hasClass("desabilitado")){
            $("#sms-gerarCodigo").css("display","none");
            $("#escolheDispositivo").css("display","none");
            $("#sms-confirmacao").addClass("hide");
            $("#sms-codigoRecebidoOk").css("display","none");
            $("#sms-codigoOk").css("display","none");
            $("#sms-validado").removeClass("hide");
            $("#sms-entraSenha").removeClass("hide");
        }
    });
    $("input#sms-entraSenha").keyup(function(e){
        var nextStep = $(this).attr("data-idnextstep");
            if(this.value == "" || this.value == this.defaultValue){
                $("#"+nextStep).addClass("desabilitado");
            }else{
                $("#"+nextStep).removeClass("desabilitado");
            }
    });

    /*****************************************************************/
    /***** SHOW / HIDE Elementos internos ?????????????????????? *****/
    /*****************************************************************/


    $(".seleciona-linha-clique").click(function() {
        var contSelects = $(this).parents(".seleciona-linha");

        if (!contSelects.hasClass("multipla-selecao")) {
            $(this).toggleClass("ativo");
            /*$(this).find(".seleciona-radio").attr('checked','checked');*/
        } else {
            if (!$(this).hasClass("ativo")) {
                contSelects.find(".seleciona-linha-clique").removeClass("ativo");
                /*contSelects.find(".seleciona-radio").removeAttr("checked");*/
                $(this).addClass("ativo");
                $(".seleciona-radio").attr('checked', 'checked');
                /*$(".seleciona-radio").attr("checked");*/
            } else {
                $(this).removeClass("ativo");
                $(".seleciona-radio").removeAttr('checked');
                /*contSelects.find(".seleciona-radio").attr("checked");*/
                /*$(".seleciona-radio").removeAttr("checked");*/
            }
        }
    });

});


/*****************************************************************/
/***** Funções Diversas *****/
/*****************************************************************/
$(function($) {

    /*****************************************************************/
    /***** Voltar ao topo / Âncoras *****/
    /*****************************************************************/
    $('a[href*=#]:not([href=#])').click(function() {
        if (location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'') && location.hostname == this.hostname) {
            var target = $(this.hash);
            target = target.length ? target : $('[name=' + this.hash.slice(1) +']');
            if (target.length) {
                $('html,body').animate({
                scrollTop: target.offset().top - 120
            }, 1000);
            return false;
            }
        }
    }); // end "Voltar ao topo"

    /*****************************************************************/
    /***** data-table *****/
    /*****************************************************************/
/*
    $('.data-table').DataTable({
        "info": false,      
        "searching": false,
        "orderFixed": true,
        "pagingType": "full_numbers",
        "bLengthChange": false,
        "language": {
          "paginate": {
            "previous": "&lsaquo;",
            "first": "&laquo;",
            "next": "&rsaquo;",
            "last": "&raquo"
          }
        }
      });*/
    
}); // end Funções Diversas


/*****************************************************************/
/***** Verificar páginas com pouco conteúdo e fixar footer *****/
/*****************************************************************/
function checkFooter() {
    var alturaPagina = ($("body > header").height() + $("div#content").height() + $("body > footer").height());

    if(alturaPagina < $(window).height()){
        $("body > footer").addClass("footer-fix");
    } else {
        $("body > footer").removeClass("footer-fix");
    }
} // end checkFooter
/*****************************************************************/
/***** Tooltip e Popover - Modelos Bootstrap *****/
/*****************************************************************/

/* ===========================================================
 * bootstrap-TOOLTIP
 * http://getbootstrap.com/2.3.2/javascript.html#tooltips
 * Inspired by the original jQuery.tipsy by Jason Frame
 * ===========================================================
 * Copyright 2012 Twitter, Inc.
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
 * ========================================================== */

!function ($) {

  "use strict"; // jshint ;_;


 /* TOOLTIP PUBLIC CLASS DEFINITION
  * =============================== */

  var Tooltip = function (element, options) {
    this.init('tooltip', element, options)
  }

  Tooltip.prototype = {

    constructor: Tooltip

  , init: function (type, element, options) {
      var eventIn
        , eventOut

      this.type = type
      this.$element = $(element)
      this.options = this.getOptions(options)
      this.enabled = true

      if (this.options.trigger == 'click') {
        this.$element.on('click.' + this.type, this.options.selector, $.proxy(this.toggle, this))
      } else if (this.options.trigger != 'manual') {
        eventIn = this.options.trigger == 'hover' ? 'mouseenter' : 'focus'
        eventOut = this.options.trigger == 'hover' ? 'mouseleave' : 'blur'
        this.$element.on(eventIn + '.' + this.type, this.options.selector, $.proxy(this.enter, this))
        this.$element.on(eventOut + '.' + this.type, this.options.selector, $.proxy(this.leave, this))
      }

      this.options.selector ?
        (this._options = $.extend({}, this.options, { trigger: 'manual', selector: '' })) :
        this.fixTitle()
    }

  , getOptions: function (options) {
      options = $.extend({}, $.fn[this.type].defaults, options, this.$element.data())

      if (options.delay && typeof options.delay == 'number') {
        options.delay = {
          show: options.delay
        , hide: options.delay
        }
      }

      return options
    }

  , enter: function (e) {
      var self = $(e.currentTarget)[this.type](this._options).data(this.type)

      if (!self.options.delay || !self.options.delay.show) return self.show()

      clearTimeout(this.timeout)
      self.hoverState = 'in'
      this.timeout = setTimeout(function() {
        if (self.hoverState == 'in') self.show()
      }, self.options.delay.show)
    }

  , leave: function (e) {
      var self = $(e.currentTarget)[this.type](this._options).data(this.type)

      if (this.timeout) clearTimeout(this.timeout)
      if (!self.options.delay || !self.options.delay.hide) return self.hide()

      self.hoverState = 'out'
      this.timeout = setTimeout(function() {
        if (self.hoverState == 'out') self.hide()
      }, self.options.delay.hide)
    }

  , show: function () {
      var $tip
        , inside
        , pos
        , actualWidth
        , actualHeight
        , placement
        , tp

      if (this.hasContent() && this.enabled) {
        $tip = this.tip()
        this.setContent()

        if (this.options.animation) {
          $tip.addClass('fade')
        }

        placement = typeof this.options.placement == 'function' ?
          this.options.placement.call(this, $tip[0], this.$element[0]) :
          this.options.placement

        inside = /in/.test(placement)

        $tip
          .detach()
          .css({ top: 0, left: 0, display: 'block' })
          .insertAfter(this.$element)

        pos = this.getPosition(inside)

        actualWidth = $tip[0].offsetWidth
        actualHeight = $tip[0].offsetHeight

        switch (inside ? placement.split(' ')[1] : placement) {
          case 'bottom':
            tp = {top: pos.top + pos.height, left: pos.left + pos.width / 2 - actualWidth / 2}
            break
          case 'top':
            tp = {top: pos.top - actualHeight, left: pos.left + pos.width / 2 - actualWidth / 2}
            break
          case 'left':
            tp = {top: pos.top + pos.height / 2 - actualHeight / 2, left: pos.left - actualWidth}
            break
          case 'right':
            tp = {top: pos.top + pos.height / 2 - actualHeight / 2, left: pos.left + pos.width}
            break
        }

        $tip
          .offset(tp)
          .addClass(placement)
          .addClass('in')
      }
    }

  , setContent: function () {
      var $tip = this.tip()
        , title = this.getTitle()

      $tip.find('.tooltip-inner')[this.options.html ? 'html' : 'text'](title)
      $tip.removeClass('fade in top bottom left right')
    }

  , hide: function () {
      var that = this
        , $tip = this.tip()

      $tip.removeClass('in')

      function removeWithAnimation() {
        var timeout = setTimeout(function () {
          $tip.off($.support.transition.end).detach()
        }, 500)

        $tip.one($.support.transition.end, function () {
          clearTimeout(timeout)
          $tip.detach()
        })
      }

      $.support.transition && this.$tip.hasClass('fade') ?
        removeWithAnimation() :
        $tip.detach()

      return this
    }

  , fixTitle: function () {
      var $e = this.$element
      if ($e.attr('title') || typeof($e.attr('data-original-title')) != 'string') {
        $e.attr('data-original-title', $e.attr('title') || '').removeAttr('title')
      }
    }

  , hasContent: function () {
      return this.getTitle()
    }

  , getPosition: function (inside) {
      return $.extend({}, (inside ? {top: 0, left: 0} : this.$element.offset()), {
        width: this.$element[0].offsetWidth
      , height: this.$element[0].offsetHeight
      })
    }

  , getTitle: function () {
      var title
        , $e = this.$element
        , o = this.options

      title = $e.attr('data-original-title')
        || (typeof o.title == 'function' ? o.title.call($e[0]) :  o.title)

      return title
    }

  , tip: function () {
      return this.$tip = this.$tip || $(this.options.template)
    }

  , validate: function () {
      if (!this.$element[0].parentNode) {
        this.hide()
        this.$element = null
        this.options = null
      }
    }

  , enable: function () {
      this.enabled = true
    }

  , disable: function () {
      this.enabled = false
    }

  , toggleEnabled: function () {
      this.enabled = !this.enabled
    }

  , toggle: function (e) {
      var self = $(e.currentTarget)[this.type](this._options).data(this.type)
      self[self.tip().hasClass('in') ? 'hide' : 'show']()
    }

  , destroy: function () {
      this.hide().$element.off('.' + this.type).removeData(this.type)
    }

  }


 /* TOOLTIP PLUGIN DEFINITION
  * ========================= */

  $.fn.tooltip = function ( option ) {
    return this.each(function () {
      var $this = $(this)
        , data = $this.data('tooltip')
        , options = typeof option == 'object' && option
      if (!data) $this.data('tooltip', (data = new Tooltip(this, options)))
      if (typeof option == 'string') data[option]()
    })
  }

  $.fn.tooltip.Constructor = Tooltip

  $.fn.tooltip.defaults = {
    animation: true
  , placement: 'top'
  , selector: false
  , template: '<div class="tooltip"><div class="tooltip-arrow"></div><div class="tooltip-inner"></div></div>'
  , trigger: 'hover'
  , title: ''
  , delay: 0
  , html: false
  }

}(window.jQuery);

/* ===========================================================
 * bootstrap-POPOVER
 * http://getbootstrap.com/2.3.2/javascript.html#popovers
 * ===========================================================
 * Copyright 2012 Twitter, Inc.
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
 * ========================================================== */

!function ($) {

  "use strict"; // jshint ;_;


 /* POPOVER PUBLIC CLASS DEFINITION
  * =============================== */

  var Popover = function (element, options) {
    this.init('popover', element, options)
  }


  /* NOTE: POPOVER EXTENDS BOOTSTRAP-TOOLTIP.js
     ========================================== */

  Popover.prototype = $.extend({}, $.fn.tooltip.Constructor.prototype, {

    constructor: Popover

  , setContent: function () {
      var $tip = this.tip()
        , title = this.getTitle()
        , content = this.getContent()

      $tip.find('.popover-title')[this.options.html ? 'html' : 'text'](title)
      $tip.find('.popover-content > *')[this.options.html ? 'html' : 'text'](content)

      $tip.removeClass('fade top bottom left right in')
    }

  , hasContent: function () {
      return this.getTitle() || this.getContent()
    }

  , getContent: function () {
      var content
        , $e = this.$element
        , o = this.options

      content = $e.attr('data-content')
        || (typeof o.content == 'function' ? o.content.call($e[0]) :  o.content)

      return content
    }

  , tip: function () {
      if (!this.$tip) {
        this.$tip = $(this.options.template)
      }
      return this.$tip
    }

  , destroy: function () {
      this.hide().$element.off('.' + this.type).removeData(this.type)
    }

  })


 /* POPOVER PLUGIN DEFINITION
  * ======================= */

  $.fn.popover = function (option) {
    return this.each(function () {
      var $this = $(this)
        , data = $this.data('popover')
        , options = typeof option == 'object' && option
      if (!data) $this.data('popover', (data = new Popover(this, options)))
      if (typeof option == 'string') data[option]()
    })
  }

  $.fn.popover.Constructor = Popover

  $.fn.popover.defaults = $.extend({} , $.fn.tooltip.defaults, {
    placement: 'right'
  , trigger: 'click'
  , content: ''
  , template: '<div class="popover"><div class="arrow"></div><div class="popover-inner"><h3 class="popover-title"></h3><div class="popover-content"><p></p></div></div></div>'
  });

  
}(window.jQuery);