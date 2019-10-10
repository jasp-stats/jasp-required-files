shinyServer(function(input, output,session) {
  p1=iris%>%ggplot(aes(x=Sepal.Length,y=Sepal.Width,colour=Species))+geom_point()
  p2=iris%>%ggplot(aes(x=Sepal.Length,y=Sepal.Width))+geom_line()+geom_point((aes(colour=Petal.Width)))
  p3=list(p1=p1,p2=p2)
  
  output$p<-renderPlot({p1})
  outp1<-callModule(ggEdit,'pOut1',obj=reactive(list(p1=p1)))
  outp2<-callModule(ggEdit,'pOut2',obj=reactive(p3),showDefaults=T,height=300)
  
  output$x1<-renderUI({
    layerTxt=outp1()$UpdatedLayerCalls$p1[[1]]
    aceEditor(outputId = 'layerAce',value=layerTxt,
              mode = "r", theme = "chrome", 
              height = "100px", fontSize = 12,wordWrap = T)
  })  
  
  output$x2<-renderUI({
    
    themeTxt=outp1()$UpdatedThemeCalls$p1
    
    if(is.null(themeTxt)) themeTxt <- ' '
    
    aceEditor(outputId = 'themeAce',value=themeTxt,
              mode = "r", theme = "chrome", 
              height = "100px", fontSize = 12,wordWrap = T)
  })  
  
})