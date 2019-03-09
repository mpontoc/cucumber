class PesquisaGoogle < SitePrism::Page

#set_url 'http://www.saraiva.com.br'

set_url 'http://www.google.com.br'

element :barraPesquisa, 'input[name="q"]' 

# é nessário a hashtag pois o SitePrims utiliza CssSelector, neste caso utilizei xpath completo

#element :barraPesquisa, 'input#q' # exemplo xpath com CssSelector

element :btnPesquisa, 'button[name="btnK"]'


    def fazPesquisa
        
        barraPesquisa.set 'selenium ruby'
        #btnPesquisa.click
        barraPesquisa.native.send_keys(:return)
    end



end