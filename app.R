suppressMessages(library(shiny))
suppressMessages(library(ggplot2))
suppressMessages(library(plotly))
suppressMessages(library(shinyBS))
suppressMessages(library(shinythemes))
suppressMessages(library(stringr))
suppressMessages(library(tibble))

ui <- fluidPage(theme = shinytheme("flatly"),
    fluidRow(
        titlePanel(
            h1(id="big-title","Simulador: Carro ou Uber?", align = "center"),
            tags$head(tags$style(HTML("#big-title{color: #5d8fff;}")))),
            
            column(1,
                   numericInput(inputId = "distancia",
                                value = 300,
                                label = p("Distância (km)", tipify(icon("info-circle"),title = "Média mensal em kilometros")))),
            ## TODO: Em uma versão futura, poderia perguntar de onde para onde é o deslocamento (Trabalho X Casa / Casa x Trabalho) e calcular a distancia automaticamente via API do Google
            
            column(1,
                   numericInput(inputId = "autonomia",
                                value = 12,
                                step = 0.02,
                                label = p("Autonomia (km/l)", tipify(icon("info-circle"),title = "Consumo médio por litro (km/l)")))),
            ## TODO: Em uma versão futura, poderia ter um combobox com todos os modelos de veiculo (puxar via webscrapping da tabela FIPE) e criar um DB com o consumo médio de cada carro
            ## TODO: Aqui poderia ter anuncios de vídeos YT como reduzir o consumo por litros
            
            column(1,
                   numericInput(inputId = "combustivel",
                                value = 5.50,
                                step = 0.01,
                                label = p("Valor Combustível"))),
            ## TODO: Em uma versão futura, poderia ter um combo do tipo de combustível e carregar o valor do acordo com o valor médio do combustível na localidade selecionada.
        
            column(1,
                   numericInput(inputId = "veiculo",
                                value = 30000,
                                step = 1,
                                label = p("Valor do Carro", tipify(icon("info-circle"),title = "Valor de venda do carro (R$)")))),   
            ## TODO: Aqui poderia ter anuncios de revendedores, OLX, etc..
        
            column(1,
                   numericInput(inputId = "seguro",
                                value = 0,
                                step = 1,
                                label = p("Seguro (R$)", tipify(icon("info-circle"),title = "Valor anual do Seguro do Carro (R$)")))),
            ## TODO: Aqui poderia ter anuncios sobre seguros mais baratos, caso o usuário inseriva valor
        
            column(1,
                   numericInput(inputId = "ipva",
                                value = 900,
                                step = 1,
                                label = p("IPVA (R$)", tipify(icon("info-circle"),title = "Valor anual do IPVA do Carro (R$)")))),
            ## TODO: Em uma versão futura, poderia trazer o valor do IPVA calculado automaticamente pelo valor do carro (FIPE) e pelo estado (para saber o valor do %).
                
            column(1,
                   numericInput(inputId = "manutencao",
                                value = 500,
                                step = 1,
                                label = p("Manutenção (R$)", tipify(icon("info-circle"),title = "Valor anual gasto com Manutenção do Carro (R$)")))),
            ## TODO: Aqui poderia ter anuncios de oficinas, caso o usuário inseriva valor
        
            column(1,
                   numericInput(inputId = "estacionamento",
                                value = 0,
                                step = 1,
                                label = p("Estacionamento (R$)", tipify(icon("info-circle"),title = "Valor anual gasto com Estacionamento do Carro (R$)")))),
        
            column(1,
                   numericInput(inputId = "multas",
                                value = 100,
                                step = 1,
                                label = p("Multas (R$)", tipify(icon("info-circle"),title = "Valor anual gasto com Multas do Carro (R$)")))),
            ## TODO: Aqui poderia ter anuncios de advogados que trabalham com multas, caso o usuário inseriva valor
               
            column(1,
                   numericInput(inputId = "licenciamento",
                                value = 85,
                                step = 1,
                                label = p("Licenciamento (R$)", tipify(icon("info-circle"),title = "Valor anual gasto com Licenciamento do Carro (R$)")))),
            ## TODO: Em uma versão futura, poderia trazer o valor automaticamente pelo estado
            
            column(1,
                   numericInput(inputId = "seguro_obrigatorio",
                                value = 67,
                                step = 1,
                                label = p("Seguro Obrig.", tipify(icon("info-circle"),title = "Valor anual gasto com Seguro Obrigatório do Carro (R$)")))),
            ## TODO: Em uma versão futura, poderia trazer o valor automaticamente pelo estado
        
            column(1,
                   numericInput(inputId = "taxa",
                                value = 8,
                                step = 0.1,
                                label = p("Taxa de rend.", tipify(icon("info-circle"),title = "Taxa de rendimento anual em %, caso seu dinheiro fosse aplicado"))))),
            ## TODO: Aqui poderia ter anuncios de investimentos
        
           
            ## TODO: Aqui poderia ter anuncios da uber
            ## TODO: Aqui poderia ter a opção de seleção do tipo de Uber: Black, Simples, etc..
        
            ### UBER
        fluidRow(
            column(2,
                   numericInput(inputId = "qtd_corridas_uber",
                                value = 44,
                                label = p("Corridas por mês", tipify(icon("info-circle"),title = "Média mensal em kilometros")))),
            
            column(2,
                   numericInput(inputId = "ppb_uber",
                                value = 2,
                                step = 0.01,
                                label = p("Preço por bandeira", tipify(icon("info-circle"),title = "Consumo médio por litro (km/l)")))),
            
            column(2,
                   numericInput(inputId = "ppkm_uber",
                                value = 1.4,
                                step = 0.01,
                                label = p("Preço por km percorrido"))),
            
            column(2,
                   numericInput(inputId = "ppm_uber",
                                value = 0.26,
                                step = 0.01,
                                label = p("Preço por minuto", tipify(icon("info-circle"),title = "Valor de venda do carro (R$)")))),   
            
            column(2,
                   numericInput(inputId = "tc_uber",
                                value = 20,
                                step = 1,
                                label = p("Tempo da corrida (min)", tipify(icon("info-circle"),title = "Valor anual do Seguro do Carro (R$)")))),
        
            column(2,
                   numericInput(inputId = "cc_uber",
                                value = 0.75,
                                step = 0.01,
                                label = p("Custo fixo da Corrida (R$)", tipify(icon("info-circle"),title = "Valor anual do IPVA do Carro (R$)")))),
        
        ),
    
    
    fluidRow(
        column(3, h3("Resultado da Análise: "),align="right"),
        column(1, h3(textOutput(outputId = "frase")),align="left"),
        column(3, h4(textOutput(outputId = "frase2")),
                  h4(textOutput(outputId = "frase3"))),
        column(4, plotOutput(outputId = "chart"))
        
    ),
    fluidRow(
        tags$a(". Desenvolvido por Analisando Dados. Para mais informações, clique aqui.",
               href = "https://www.instagram.com/analisando_dados/")
    ),
    fluidRow(
        tags$p("* Custo de oportunidade calculado com base na SELIC 2,25% aa.")
    ),
    fluidRow(
        tags$a(". Link do projeto no GitHub.",
               href = "https://github.com/igorfarah")
    )
    
    
)

server <- function(input, output) {
    
    
    # Coleta de inputs do carro
    distancia <- renderText(input$distancia)
    autonomia <- renderText(input$autonomia)
    combustivel <- renderText(input$combustivel)
    veiculo <- renderText(input$veiculo)
    seguro <- renderText(input$seguro)
    ipva <- renderText(input$ipva)
    manutencao <- renderText(input$manutencao)
    estacionamento <- renderText(input$estacionamento)
    multas <- renderText(input$multas)
    licenciamento <- renderText(input$licenciamento)
    seguro_obrigatorio <- renderText(input$seguro_obrigatorio)
    taxa <- renderText(input$taxa)
    
    
    # Coleta de inputs do uber
    qtd_corridas_uber <- renderText(input$qtd_corridas_uber)
    ppb_uber <- renderText(input$ppb_uber)
    ppkm_uber <- renderText(input$ppkm_uber)
    ppm_uber <- renderText(input$ppm_uber)
    tc_uber <- renderText(input$tc_uber)
    cc_uber <- renderText(input$cc_uber)
    
    
    # Calcular custo do carro
    gasto_combustivel <- reactive ({
        (as.double(distancia()) / as.double(autonomia())) * as.double(combustivel()) * 12
    })
    
    gasto_mensal <- reactive ({
        (gasto_combustivel() * (1 + as.double(taxa()) / 100)) + 
        (as.double(seguro()) * (1 + as.double(taxa()) / 100)) + 
        (as.double(ipva()) * (1 + as.double(taxa()) / 100)) +
        (as.double(estacionamento()) * (1 + as.double(taxa()) / 100)) + 
        (as.double(manutencao()) * (1 + as.double(taxa()) / 100)) + 
        (as.double(multas()) * (1 + as.double(taxa()) / 100)) + 
        (as.double(licenciamento()) * (1 + as.double(taxa()) / 100)) + 
        (as.double(seguro_obrigatorio()) * (1 + as.double(taxa()) / 100))
    })
    
    depreciacao <- reactive ({
        as.double(veiculo()) * as.double(taxa()) / 100
    })
    
    custo_oportunidade <- reactive ({
        as.integer(veiculo()) * 0.0225 # Selic # Consultar selic mais recente
    })
    
    vl_veic_aplic <- reactive ({
        as.integer(veiculo()) * (as.double(taxa()) / 100)
    })
    
    custo_carro <- reactive ({
        gasto_mensal() + 
        depreciacao() +
        custo_oportunidade() +
        vl_veic_aplic()
    })
        
    
    # Calcular custo do uber
    km_por_corrida <- reactive ({
        as.double(distancia()) / 30 / 2
    })
    
    preco_medio_corrida <- reactive ({
        as.double(cc_uber()) + 
        (as.double(ppm_uber()) * as.double(tc_uber())) + 
        (as.double(ppkm_uber()) * km_por_corrida()) + 
        as.double(ppb_uber())
    })

    custo_uber <- reactive ({
        as.double(qtd_corridas_uber()) *
        preco_medio_corrida() * 12 * (1 + (as.double(taxa()) / 100))
    })
    
    
    ## Validação final e print de valores
    
    output$frase <- renderText(ifelse(custo_uber()>custo_carro(),"CARRO","UBER"))
    
    output$frase2 <- renderText(paste("Custo total Carro: R$ ",
                                      format(c(trunc(custo_carro(),0)), digits = 2, nsmall = 2, big.mark = ".",decimal.mark = ","),
                                      sep=""))
    
    output$frase3 <- renderText(paste("Custo total Uber: R$ ",
                                      format(c(trunc(custo_uber(),0)), digits = 2, nsmall = 2, big.mark = ".",decimal.mark = ","),
                                      sep=""))
    
    
    output$chart <- renderPlot(barplot(height = c(custo_carro(),custo_uber()),
                                 horiz = F,
                                 col = c("#80eae4","#5d8fff"),
                                 names.arg = c("Carro","Uber"),
                                 border = NA,
                                 main = "Comparativo",
                                 axes = T,
                                 xpd=T,
                                 beside = T))
    

}

shinyApp(ui, server)






#text(bp,pos=4,labels = c(50,10))




## INPUTS
# actionButton() - botão para executar uma ação.
# checkboxGroupInput() - um grupo de check boxes.
# checkboxInput() - um único check box.
# dateInput() - um calendário para seleção de data.
# dateRangeInput() - um par de calendários para escolher um intervalo de datas.
# fileInput() - uma ferramenta para auxiliar o upload de arquivos.
# numericInput() - Um campo para enviar números.
# radioButtons() - Um conjunto de botões para seleção.
# selectInput() - Um select box com um conjunto de opções.
# sliderInput() - Um slider.
# textInput() - Um campo para enviar texto.

## OUTPUTS
# dataTableOutput() - para data frames.
# htmlOutput() ou uiOutput() - para código HTML.
# imageOutput() - para imagens.
# plotOutput() - para gráficos.
# tableOutput() - para tabelas.
# textOutput() - para textos.
# verbatimTextOutput() - para textos não-formatados.

## SERVER
# renderDataTable() - data frames.
# renderImage() - imagens.
# renderPlot() - gráficos.
# renderPrint() - qualquer printed output.
# renderTable() - data frames, matrizes, e outras estruturas em forma de tabela.
# renderText() - strings.
# renderUI() - um elemento do UI ou HTML.



