#install.packages(c("shiny","shinythemes","bslib","DT","ggplot2","tidyr","dplyr","fmsb"))

library(shiny)
#library(shinythemes)
library(bslib)
library(DT)
library(ggplot2)
library(tidyr)
library(dplyr)
library(fmsb)

ui <- fluidPage(
  theme = bs_theme(
    version = 5,
    bootswatch = "flatly",
    primary = "#3498db"
  ),
  tags$head(
    tags$style(HTML("
      ::-webkit-scrollbar {
        width: 8px;
    }
    ::-webkit-scrollbar-track {
        background: #1e1e1e;
    }
    ::-webkit-scrollbar-thumb {
        background-color: #555;
        border-radius: 10px;
        border: 2px solid #1e1e1e;
    }
    ::-webkit-scrollbar-thumb:hover {
        background: #888;
    }
    .navbar-nav > .active > a,
    .navbar-nav > .active > a:focus,
    .navbar-nav > .active > a:hover {
        background-color: #444 !important;   
        color: white !important;             
        border-radius:;
    }
    .navbar-nav > li > a {
        color: #cccccc !important;
    }
    * {
        scrollbar-width: thin;
        scrollbar-color: #555 #1e1e1e;
    }
    body {
        background-color: #0b0c10 !important;
        color: white !important;             
        min-height: 100vh;
    }
    .card {
        box-shadow: 0 4px 8px 0 rgba(255,255,255,0.2);
        transition: 0.3s;
        border-radius: 10px;
        margin-bottom: 20px;
        background-color: rgba(30, 30, 30, 0.95); 
        color: white;
    }
    .tall-card {
        min-height: 280px;
        padding: 0px;
    }
    .container, .container-fluid {
        width: 100% !important;
        max-width: 100% !important;
        padding-left: 15px !important;
        padding-right: 15px !important;
    }
    .card:hover {
        box-shadow: 0 8px 16px 0 rgba(0,0,0,0.2);
    }
    .personality-image {
        max-width: 100%;
        border-radius: 5px;
        margin-top: 10px;
        box-shadow: 0 3px 6px rgba(0,0,0,0.16);
    }
    .result-card {
        padding: 20px;
        background-color: rgba(248, 249, 250, 0.9);
        border-radius: 10px;
    }
    .app-title {
        text-align: center;
        padding: 20px;
        color: white;
        background-color: #0b0c10;
        border-radius: 10px;
        margin-bottom: 20px;
        max-height: 160px;
    }
    .slider-label {
        font-size: 14px;
        padding: 10px 5px;
    }
    .slider-container {
        display: flex;
        align-items: center;
        gap: 15px;
        margin: 15px 0;
    }
    .slider-left {
        flex: 2;
        text-align: right;
    }
    .slider-right {
        flex: 2;
        text-align: left;
    }
    .slider-center {
        flex: 1;
        min-width: 150px;
    }
    .btn-primary {
        background-color: #3498db;
        border-color: #2980b9;
    }
    .btn-primary:hover {
        background-color: #2980b9;
        border-color: #2471a3;
    }
    .card-header {
        background-color: rgba(60, 60, 60, 0.95);
        color: white;
        font-weight: bold;
    }
    .tab-content {
        background-color: rgba(20, 20, 20, 0.9);
        color: white;
        border-radius: 0 0 10px 10px;
        padding: 20px;
    }
    .profile-table-container table {
        background-color: transparent; 
        color: #ffffff; 
        width: 100%;
        border-collapse: collapse;
        margin: 0;
    }
    .profile-table-container th,
    .profile-table-container td {
        background-color: rgba(20, 20, 20, 0.95); 
        color: #ffffff;
        padding: 8px 12px;
        border: none; 
    }
    .profile-table-container th {
        font-weight: bold;
    }
    .profile-table-container tr {
        background-color: #1e1e1e;
    }
    .profile-table-container tr:hover {
        background-color: #2a2a2a;
    }
    .results-container {
        width: 100%;
        margin: 0;
    }
    .trait-box {
        width: 100%;
        margin-bottom: 15px;
    }
    .gradient-text {
        background: linear-gradient(90deg, #3b82f6, #a78bfa, #f472b6, #34d399);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        font-weight: bold;
        font-family: 'Montserrat', sans-serif;
    }
      .splash-container {
          height: 100vh;
          display: flex;
          flex-direction: column;
          justify-content: center;
          align-items: center;
          text-align: center;
          background: linear-gradient(135deg, #0b0c10 0%, #1f2833 100%);
          padding: 20px;
      }
      
      .splash-logo {
          max-width: 250px;
          margin-bottom: 30px;
      }
      
      .splash-title {
          font-size: 4rem;
          margin-bottom: 20px;
      }
      
      .splash-description {
          font-size: 1.5rem;
          max-width: 800px;
          margin-bottom: 50px;
          color: #c5c6c7;
      }
      
      .splash-button {
          background: linear-gradient(90deg, #3b82f6, #50e3c2);
          color: #fff;
          border: none;
          border-radius: 50px;
          padding: 15px 50px;
          font-size: 1.2rem;
          font-weight: bold;
          cursor: pointer;
          transition: all 0.3s ease;
          box-shadow: 0 10px 20px rgba(0,0,0,0.3);
      }
      
      .splash-button:hover {
          transform: translateY(-5px);
          box-shadow: 0 15px 30px rgba(0,0,0,0.4);
      }
    "))
  ),
  
  conditionalPanel(
    condition = "!output.showMainContent",
    div(class = "splash-container",
        img(src = "logo1.png", class = "splash-logo", alt = "YouNiverse Logo"),
        h1(class = "gradient-text splash-title", "YouNiverse"),
        p(class = "splash-description", 
          "Embark on a journey through the cosmos of your personality. Discover who you truly are and unlock the secrets of your unique personality profile."),
        actionButton("enterButton", "Begin Your Journey", class = "splash-button")
    )
  ),
  
  conditionalPanel(
    condition = "output.showMainContent",
    div(
      div(class = "app-title",
          style = "display: flex; align-items: center; justify-content: center; flex-wrap: wrap;",
          div(
            style = "display: flex; align-items: center; margin-right: 20px;",
            img(src = "logo1.png", alt = "Ghost mascot", 
                style = "max-width: 150px; height: auto; margin-right: 15px;"),
            div(
              h1(class="gradient-text", "YouNiverse", 
                 style = "font-weight: bold; font-family: 'Montserrat', sans-serif; color: #ffffff; margin: 0;margin-top: 25px;"),
              p("Explore the cosmos of You",
                style = "font-family: 'Open Sans', sans-serif; color: #e0e0e0; margin-top: 5px;")
            )
          )
      ),
      
      navset_card_tab(
        id = "mainTabset",
        title = "Personality Assessment",
        
        nav_panel(
          title = "Home",
          div(
            style = "padding: 20px;",
            
            div(
              style = "display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px;",
              div(
                div(
                  style = "display: flex; align-items: center; gap: 15px;",
                  icon("brain", class = "fa-2x", style = "color: #50e3c2;margin-bottom: 2.5rem"),
                  h1("TypeQuest", style = "font-size: 2.5rem; font-weight: bold; margin: 0; color: white; margin-bottom: 2.5rem")
                ),
                p("Get Ready to Discover Who You are", style = "font-size: 1.5rem; font-weight: bold; margin-bottom: 0.5rem;"),
                p(HTML("Powered by our <span style='color:#50e3c2;'>AI</span>-Driven Personality Engine"), 
                  style = "color: white;font-size: 1.5rem; font-weight: bold; margin-bottom: 3rem;"),
                
                div(
                  style = "display: flex; flex-direction: column; gap: 30px; margin-bottom: 30px;",
                  
                  div(
                    style = "color: #ffffff; font-size: 17px; line-height: 1.6;",
                    
                    h3(" How Your MBTI Type is Determined", style = "color: #50e3c2; font-size: 1.5rem; margin-top: 10px;"),
                    
                    p("The 16 MBTI personality types are built by analyzing your unique position across four core personality dimensions:"),
                    
                    tags$ul(
                      tags$li(strong("Extraversion (E) vs. Introversion (I)")),
                      tags$li(strong("Sensing (S) vs. Intuition (N)")),
                      tags$li(strong("Thinking (T) vs. Feeling (F)")),
                      tags$li(strong("Judging (J) vs. Perceiving (P)"))
                    ),
                    
                    br(),
                    
                    p(HTML("Each combination of one trait from each pair forms a 4-letter type — like <span style='color:#50e3c2; font-weight:bold;'>INFJ</span>, <span style='color:#50e3c2; font-weight:bold;'>ESTP</span>, and many more.")),
                    
                    h4(" How Scores Are Interpreted:", style = "color: #50e3c2; font-size: 2px; margin-top: 20px;"),
                    
                    tags$ul(
                      tags$li(HTML("<strong>Introversion Score:</strong> <span style='color:#50e3c2;'>Less than 5</span> = Introverted, <span style='color:#50e3c2;'>Greater than 5</span> = Extraverted")),
                      tags$li(HTML("<strong>Sensing Score:</strong> <span style='color:#50e3c2;'>Less than 5</span> = Intuitive, <span style='color:#50e3c2;'>Greater than 5</span> = Sensing")),
                      tags$li(HTML("<strong>Thinking Score:</strong> <span style='color:#50e3c2;'>Less than 5</span> = Feeling, <span style='color:#50e3c2;'>Greater than 5</span> = Thinking")),
                      tags$li(HTML("<strong>Judging Score:</strong> <span style='color:#50e3c2;'>Less than 5</span> = Perceiving, <span style='color:#50e3c2;'>Greater than 5</span> = Judging"))
                    ),
                    
                    p("These insights help reveal your natural preferences and pinpoint your MBTI type, unlocking a deeper understanding of yourself. ")
                  )
                ),
                
                
                
                actionButton("instructions", "INSTRUCTIONS", 
                             style = "background-color: #50e3c2; color: #000000; border: none; border-radius: 50px; padding: 15px 40px; font-size: 1rem; font-weight: bold;")
              ),
              
              div(
                style = "text-align: center;",
                img(src = "icon1.png", alt = "Ghost mascot", 
                    style = "max-width: 300px; height: auto;")
              )
            ),
            
            # Personality types section
            div(
              style = "margin-top: 60px;",
              div(
                style = "display: flex; align-items: center; margin-bottom: 30px;",
                h2("16 Personality Types", style = "font-size: 1.5rem; margin: 0; margin-right: 10px;"),
                div(style = "width: 20px; height: 20px; background-color: #FFFFFF; clip-path: polygon(0 0, 0 100%, 100% 50%);")
              ),
              
              # First row of personality types
              div(
                style = "display: grid; grid-template-columns: repeat(6, 1fr); gap: 15px; margin-bottom: 30px;",
                
                # INFJ
                div(
                  style = "display: flex; flex-direction: column; align-items: center; text-align: center;",
                  actionButton(
                    inputId = "btn_INFJ",
                    label = div(
                      img(src = "INFJ.jpg", alt = "INFJ",
                          style = "border: 5px solid #50e3c2; border-radius: 15px; width: 150px; height: 150px; margin-bottom: 10px;"),
                      p("INFJ", style = "font-weight: bold; margin: 0; margin-bottom: 5px;"),
                      p("Advocate", style = "margin: 0; font-size: 14px;")
                    ),
                    style = "background: none; border: none; padding: 0;"
                  )
                ),
                
                # INTJ
                div(
                  style = "display: flex; flex-direction: column; align-items: center; text-align: center;",
                  actionButton(
                    inputId = "btn_INTJ",
                    label = div(
                      img(src = "INTJ.jpg", alt = "INTJ",
                          style = "border: 5px solid #50e3c2; border-radius: 15px; width: 150px; height: 150px; margin-bottom: 10px;"),
                      p("INTJ", style = "font-weight: bold; margin: 0; margin-bottom: 5px;"),
                      p("Mastermind", style = "margin: 0; font-size: 14px;")
                    ),
                    style = "background: none; border: none; padding: 0;"
                  )
                ),
                
                # ENFP
                div(
                  style = "display: flex; flex-direction: column; align-items: center; text-align: center;",
                  actionButton(
                    inputId = "btn_ENFP",
                    label = div(
                      img(src = "ENFP.jpg", alt = "ENFP",
                          style = "border: 5px solid #50e3c2; border-radius: 15px; width: 150px; height: 150px; margin-bottom: 10px;"),
                      p("ENFP", style = "font-weight: bold; margin: 0; margin-bottom: 5px;"),
                      p("Campaigner", style = "margin: 0; font-size: 14px;")
                    ),
                    style = "background: none; border: none; padding: 0;"
                  )
                ),
                
                # ENTP
                div(
                  style = "display: flex; flex-direction: column; align-items: center; text-align: center;",
                  actionButton(
                    inputId = "btn_ENTP",
                    label = div(
                      img(src = "ENTP.jpg", alt = "ENTP",
                          style = "border: 5px solid #50e3c2; border-radius: 15px; width: 150px; height: 150px; margin-bottom: 10px;"),
                      p("ENTP", style = "font-weight: bold; margin: 0; margin-bottom: 5px;"),
                      p("Visionary", style = "margin: 0; font-size: 14px;")
                    ),
                    style = "background: none; border: none; padding: 0;"
                  )
                ),
                
                # INFP
                div(
                  style = "display: flex; flex-direction: column; align-items: center; text-align: center;",
                  actionButton(
                    inputId = "btn_INFP",
                    label = div(
                      img(src = "INFP.jpg", alt = "INFP",
                          style = "border: 5px solid #50e3c2; border-radius: 15px; width: 150px; height: 150px; margin-bottom: 10px;"),
                      p("INFP", style = "font-weight: bold; margin: 0; margin-bottom: 5px;"),
                      p("Mediator", style = "margin: 0; font-size: 14px;")
                    ),
                    style = "background: none; border: none; padding: 0;"
                  )
                ),
                
                # ISFP
                div(
                  style = "display: flex; flex-direction: column; align-items: center; text-align: center;",
                  actionButton(
                    inputId = "btn_ISFP",
                    label = div(
                      img(src = "ISFP.jpg", alt = "ISFP",
                          style = "border: 5px solid #50e3c2; border-radius: 15px; width: 150px; height: 150px; margin-bottom: 10px;"),
                      p("ISFP", style = "font-weight: bold; margin: 0; margin-bottom: 5px;"),
                      p("Artist", style = "margin: 0; font-size: 14px;")
                    ),
                    style = "background: none; border: none; padding: 0;"
                  )
                )
              ),
              
              # Second row of personality types
              div(
                style = "display: grid; grid-template-columns: repeat(6, 1fr); gap: 15px; margin-bottom: 30px;",
                
                # ENFJ
                div(
                  style = "display: flex; flex-direction: column; align-items: center; text-align: center;",
                  actionButton(
                    inputId = "btn_ENFJ",
                    label = div(
                      img(src = "ENFJ.jpg", alt = "ENFJ",
                          style = "border: 5px solid #50e3c2; border-radius: 15px; width: 150px; height: 150px; margin-bottom: 10px;"),
                      p("ENFJ", style = "font-weight: bold; margin: 0; margin-bottom: 5px;"),
                      p("Protagonist", style = "margin: 0; font-size: 14px;")
                    ),
                    style = "background: none; border: none; padding: 0;"
                  )
                ),
                
                # ESFJ
                div(
                  style = "display: flex; flex-direction: column; align-items: center; text-align: center;",
                  actionButton(
                    inputId = "btn_ESFJ",
                    label = div(
                      img(src = "ESFJ.jpg", alt = "ESFJ",
                          style = "border: 5px solid #50e3c2; border-radius: 15px; width: 150px; height: 150px; margin-bottom: 10px;"),
                      p("ESFJ", style = "font-weight: bold; margin: 0; margin-bottom: 5px;"),
                      p("Consultant", style = "margin: 0; font-size: 14px;")
                    ),
                    style = "background: none; border: none; padding: 0;"
                  )
                ),
                
                # INTP
                div(
                  style = "display: flex; flex-direction: column; align-items: center; text-align: center;",
                  actionButton(
                    inputId = "btn_INTP",
                    label = div(
                      img(src = "INTP.jpg", alt = "INTP",
                          style = "border: 5px solid #50e3c2; border-radius: 15px; width: 150px; height: 150px; margin-bottom: 10px;"),
                      p("INTP", style = "font-weight: bold; margin: 0; margin-bottom: 5px;"),
                      p("Thinker", style = "margin: 0; font-size: 14px;")
                    ),
                    style = "background: none; border: none; padding: 0;"
                  )
                ),
                
                # ISTP
                div(
                  style = "display: flex; flex-direction: column; align-items: center; text-align: center;",
                  actionButton(
                    inputId = "btn_ISTP",
                    label = div(
                      img(src = "ISTP.jpg", alt = "ISTP",
                          style = "border: 5px solid #50e3c2; border-radius: 15px; width: 150px; height: 150px; margin-bottom: 10px;"),
                      p("ISTP", style = "font-weight: bold; margin: 0; margin-bottom: 5px;"),
                      p("Virtuoso", style = "margin: 0; font-size: 14px;")
                    ),
                    style = "background: none; border: none; padding: 0;"
                  )
                ),
                
                # ENTJ
                div(
                  style = "display: flex; flex-direction: column; align-items: center; text-align: center;",
                  actionButton(
                    inputId = "btn_ENTJ",
                    label = div(
                      img(src = "ENTJ.jpg", alt = "ENTJ",
                          style = "border: 5px solid #50e3c2; border-radius: 15px; width: 150px; height: 150px; margin-bottom: 10px;"),
                      p("ENTJ", style = "font-weight: bold; margin: 0; margin-bottom: 5px;"),
                      p("Commander", style = "margin: 0; font-size: 14px;")
                    ),
                    style = "background: none; border: none; padding: 0;"
                  )
                ),
                
                # ESTJ
                div(
                  style = "display: flex; flex-direction: column; align-items: center; text-align: center;",
                  actionButton(
                    inputId = "btn_ESTJ",
                    label = div(
                      img(src = "ESTJ.jpg", alt = "ESTJ",
                          style = "border: 5px solid #50e3c2; border-radius: 15px; width: 150px; height: 150px; margin-bottom: 10px;"),
                      p("ESTJ", style = "font-weight: bold; margin: 0; margin-bottom: 5px;"),
                      p("Executive", style = "margin: 0; font-size: 14px;")
                    ),
                    style = "background: none; border: none; padding: 0;"
                  )
                )
              ),
              
              # Third row of personality types
              div(
                style = "display: grid; grid-template-columns: repeat(6, 1fr); gap: 15px; margin-bottom: 30px;",
                
                # ISFJ
                div(
                  style = "display: flex; flex-direction: column; align-items: center; text-align: center;",
                  actionButton(
                    inputId = "btn_ISFJ",
                    label = div(
                      img(src = "ISFJ.jpg", alt = "ISFJ",
                          style = "border: 5px solid #50e3c2; border-radius: 15px; width: 150px; height: 150px; margin-bottom: 10px;"),
                      p("ISFJ", style = "font-weight: bold; margin: 0; margin-bottom: 5px;"),
                      p("Defender", style = "margin: 0; font-size: 14px;")
                    ),
                    style = "background: none; border: none; padding: 0;"
                  )
                ),
                
                # ISTJ
                div(
                  style = "display: flex; flex-direction: column; align-items: center; text-align: center;",
                  actionButton(
                    inputId = "btn_ISTJ",
                    label = div(
                      img(src = "ISTJ.jpg", alt = "ISTJ",
                          style = "border: 5px solid #50e3c2; border-radius: 15px; width: 150px; height: 150px; margin-bottom: 10px;"),
                      p("ISTJ", style = "font-weight: bold; margin: 0; margin-bottom: 5px;"),
                      p("Inspector", style = "margin: 0; font-size: 14px;")
                    ),
                    style = "background: none; border: none; padding: 0;"
                  )
                ),
                
                # ESFP
                div(
                  style = "display: flex; flex-direction: column; align-items: center; text-align: center;",
                  actionButton(
                    inputId = "btn_ESFP",
                    label = div(
                      img(src = "ESFP.jpg", alt = "ESFP",
                          style = "border: 5px solid #50e3c2; border-radius: 15px; width: 150px; height: 150px; margin-bottom: 10px;"),
                      p("ESFP", style = "font-weight: bold; margin: 0; margin-bottom: 5px;"),
                      p("Entertainer", style = "margin: 0; font-size: 14px;")
                    ),
                    style = "background: none; border: none; padding: 0;"
                  )
                ),
                
                # ESTP
                div(
                  style = "display: flex; flex-direction: column; align-items: center; text-align: center;",
                  actionButton(
                    inputId = "btn_ESTP",
                    label = div(
                      img(src = "ESTP.jpg", alt = "ESTP",
                          style = "border: 5px solid #50e3c2; border-radius: 15px; width: 150px; height: 150px; margin-bottom: 10px;"),
                      p("ESTP", style = "font-weight: bold; margin: 0; margin-bottom: 5px;"),
                      p("Dynamo", style = "margin: 0; font-size: 14px;")
                    ),
                    style = "background: none; border: none; padding: 0;"
                  )
                ),
                div(),
                div()
              ),
              uiOutput("personality_info_ui")
            )
          )
        ),
        nav_panel(
          title = "Instructions",
          div(
            style = "padding: 20px;",
            
            div(
              style = "display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px;",
              div(
                h1("16 PERSONALITY TEST.", style = "font-size: 2.5rem; font-weight: bold; margin-bottom: 0.5rem;"),
                h1("DISCOVER WHO YOU ARE.", style = "font-size: 2.5rem; font-weight: bold; margin-bottom: 2rem;")
              ),
              
              div(
                style = "text-align: center;",
                img(src = "instructions.png", alt = "Ghost mascot",
                    style = "max-width: 200px; height: auto;")
              )
            ),
            
            div(
              style = "margin-top: 40px; background-color: #1a1a1a; border-radius: 10px; padding: 30px;",
              
              div(
                style = "display: flex; align-items: center; margin-bottom: 20px;",
                h2("How to Take the Test", style = "font-size: 1.5rem; margin: 0; color: #50e3c2;")
              ),
              
              div(
                style = "display: grid; grid-template-columns: repeat(3, 1fr); gap: 30px; margin-bottom: 30px;",
                
                # Step 1
                div(
                  style = "background-color: #2a2a2a; border-left: 4px solid #50e3c2; padding: 20px; border-radius: 5px;",
                  h3("1. Be Honest", style = "color: #50e3c2; margin-top: 0;"),
                  p("Answer questions based on how you truly are, not how you wish to be seen. There are no right or wrong answers.",
                    style = "color: #e0e0e0;")
                ),
                
                # Step 2
                div(
                  style = "background-color: #2a2a2a; border-left: 4px solid #50e3c2; padding: 20px; border-radius: 5px;",
                  h3("2. Go with Your Instinct", style = "color: #50e3c2; margin-top: 0;"),
                  p("Don't overthink your responses. Your first reaction is usually the most accurate reflection of your personality.",
                    style = "color: #e0e0e0;")
                ),
                
                # Step 3
                div(
                  style = "background-color: #2a2a2a; border-left: 4px solid #50e3c2; padding: 20px; border-radius: 5px;",
                  h3("3. Answering Questions", style = "color: #50e3c2; margin-top: 0;"),
                  p("Make sure to Enter Your Age and Select the Information relevant to you. Drag the slider for each question to the direction you associate with.
                Once you have completed answering the questions Don't forget to click PREDICT MY PERSONALITY",
                    style = "color: #e0e0e0;")
                )
              ),
              
              div(
                style = "background-color: #2a2a2a; padding: 20px; border-radius: 5px; margin-bottom: 30px;",
                h3("What You'll Discover", style = "color: #50e3c2; margin-top: 0;"),
                p("This personality predictor uses the Myers-Briggs Type Indicator (MBTI) framework to suggest
             your personality type based on your responses across  the following four dimensions:", style = "color: #e0e0e0; margin-bottom: 15px;"),
                
                div(
                  style = "display: grid; grid-template-columns: repeat(2, 1fr); gap: 15px;",
                  div(
                    p(span("Extraversion (E) vs. Introversion (I)", style = "font-weight: bold; color: #ffffff;"),
                      style = "margin: 5px 0; color: #e0e0e0;"),
                    p(span("Sensing (S) vs. Intuition (N)", style = "font-weight: bold; color: #ffffff;"),
                      style = "margin: 5px 0; color: #e0e0e0;")
                  ),
                  div(
                    p(span("Thinking (T) vs. Feeling (F)", style = "font-weight: bold; color: #ffffff;"),
                      style = "margin: 5px 0; color: #e0e0e0;"),
                    p(span("Judging (J) vs. Perceiving (P)", style = "font-weight: bold; color: #ffffff;"),
                      style = "margin: 5px 0; color: #e0e0e0;")
                  )
                )
              ),
              
              div(
                style = "text-align: center;",
                actionButton("take_test", "TAKE TEST",
                             style = "background-color: #50e3c2; color: #000000; border: none; border-radius: 50px; padding: 15px 60px; font-size: 1.2rem; font-weight: bold; cursor: pointer; transition: all 0.3s ease;")
              )
            )
          )
        ),
        
        nav_panel(
          title = "Take Test",
          layout_sidebar(
            sidebar = sidebar(
              title = "Your Profile",
              width = 300,
              style = "background-color: #1A1A1A !important; color: white;",
              
              card(
                card_header("Basic Information"),
                numericInput("Age", label = "Enter your age",
                             min = 1, max = 100, value = 25),
                radioButtons("Gender",
                             label = "Select your Gender",
                             choices = list("Male" = "Male", "Female" = "Female")
                ),
                radioButtons("Education",
                             label = "Level of Education",
                             choices = list("Undergraduate / Lower" = "0",
                                            "Graduate / Higher" = "1")
                ),
                radioButtons("Interest",
                             label = "Field of Interest",
                             choices = list("Arts" = "Arts",
                                            "Sports" = "Sports",
                                            "Technology" = "Technology",
                                            "Others" = "Others",
                                            "Unknown" = "Unknown")
                )
              ),
              
              actionButton("submitbutton", "PREDICT MY PERSONALITY",
                           style = "background-color: #50e3c2; color: #000000;
                          border: none; border-radius: 50px; padding: 15px 40px;
                          font-size: 1rem; font-weight: bold;")
              
            ),
            
            card(
              class = "tall-card",
              card_header(
                span(
                  tagList(
                    icon("comments"),
                    "Interaction Style"
                  ),
                  style = "color: #50e3c2; font-weight: bold; font-size: 16px;"
                )
              ),
              h4("In a social gathering, do you feel more energized by interacting with a large group of people or by having one-on-one conversations?"),
              div(class = "slider-container",
                  div(class = "slider-left", "One-on-one conversations (I)"),
                  div(class = "slider-center", sliderInput("ei1", label = NULL, min = 1, max = 10, value = 5, step = 1)),
                  div(class = "slider-right", "Large group interactions (E)")
              )
            ),
            
            card(
              class = "tall-card",
              card_header(
                span(
                  tagList(
                    icon("search"),
                    "Information Processing"
                  ),
                  style = "color: #50e3c2; font-weight: bold; font-size: 16px;"
                )
              ),
              h4("When faced with a problem, do you prefer to rely on concrete facts and details or explore possibilities and potential meanings?"),
              div(class = "slider-container",
                  div(class = "slider-left", "Explore possibilities and potential meanings (N)"),
                  div(class = "slider-center", sliderInput("ns1", label = NULL, min = 1, max = 10, value = 5, step = 1)),
                  div(class = "slider-right", "Rely on concrete facts and details (S)")
              )
            ),
            
            card(
              class = "tall-card",
              card_header(
                span(
                  tagList(
                    icon("random"),
                    "Decision Making"
                  ),
                  style = "color: #50e3c2; font-weight: bold; font-size: 16px;"
                )
              ),
              h4("When making decisions, do you prioritize logical analysis and objective criteria or consider the impact on people and relationships?"),
              div(class = "slider-container",
                  div(class = "slider-left", "Consider the impact on people and relationships (F)"),
                  div(class = "slider-center", sliderInput("ft1", label = NULL, min = 1, max = 10, value = 5, step = 1)),
                  div(class = "slider-right", "Logical analysis and objective criteria (T)")
              )
            ),
            
            card(
              class = "tall-card",
              card_header(
                span(
                  tagList(
                    icon("spa"),
                    "Lifestyle Approach"
                  ),
                  style = "color: #50e3c2; font-weight: bold; font-size: 16px;"
                )
              ),
              h4("How do you feel about making plans and sticking to a schedule?"),
              div(class = "slider-container",
                  div(class = "slider-left", "Prefer flexibility and spontaneity (P)"),
                  div(class = "slider-center", sliderInput("pj1", label = NULL, min = 1, max = 10, value = 5, step = 1)),
                  div(class = "slider-right", "Enjoy structure and planning (J)")
              )
            ),
            
            card(
              class = "tall-card",
              card_header(
                span(
                  tagList(
                    icon("bolt"),
                    "Recharge Style"
                  ),
                  style = "color: #50e3c2; font-weight: bold; font-size: 16px;"
                )
              ),
              h4("How do you typically recharge after a busy day?"),
              div(class = "slider-container",
                  div(class = "slider-left", "Alone time to unwind (I)"),
                  div(class = "slider-center", sliderInput("ei2", label = NULL, min = 1, max = 10, value = 5)),
                  div(class = "slider-right", "Social time with others (E)")
              )
            ),
            
            card(
              class = "tall-card",
              card_header(
                span(
                  tagList(
                    icon("brain"),
                    "Learning Style"
                  ),
                  style = "color: #50e3c2; font-weight: bold; font-size: 16px;"
                )
              ),
              h4("How do you approach new information or learning?"),
              div(class = "slider-container",
                  div(class = "slider-left", "Enjoy exploring theories and concepts (N)"),
                  div(class = "slider-center", sliderInput("ns2", label = NULL, min = 1, max = 10, value = 5, step = 1)),
                  div(class = "slider-right", "Prefer practical, hands-on experiences (S)")
              )
            ),
            
            card(
              class = "tall-card",
              card_header(
                span(
                  tagList(
                    icon("heart"),
                    "Emotional Reaction Style"
                  ),
                  style = "color: #50e3c2; font-weight: bold; font-size: 16px;"
                )
              ),
              h4("How do you handle criticism or feedback?"),
              div(class = "slider-container",
                  div(class = "slider-left", "Consider the emotional aspects and how it affects relationships (F)"),
                  div(class = "slider-center", sliderInput("ft2", label = NULL, min = 1, max = 10, value = 5, step = 1)),
                  div(class = "slider-right", "Focus on the facts and seek constructive solutions (T)")
              )
            ),
            
            card(
              class = "tall-card",
              card_header(
                span(
                  tagList(
                    icon("rocket"),
                    "Project Kick-Off Style"
                  ),
                  style = "color: #50e3c2; font-weight: bold; font-size: 16px;"
                )
              ),
              h4("When starting a project, do you prefer to have a detailed plan in place or do you like to explore possibilities and figure it out as you go?"),
              div(class = "slider-container",
                  div(class = "slider-left", "Like to explore possibilities and figure it out as you go (P)"),
                  div(class = "slider-center", sliderInput("pj2", label = NULL, min = 1, max = 10, value = 5, step = 1)),
                  div(class = "slider-right", "Prefer to have a detailed plan (J)")
              )
            ),
            
            card(
              class = "tall-card",
              card_header(
                span(
                  tagList(
                    icon("handshake"),
                    "Collaboration Style"
                  ),
                  style = "color: #50e3c2; font-weight: bold; font-size: 16px;"
                )
              ),
              h4("When facing a challenge, do you prefer brainstorming ideas with others or working through it independently?"),
              div(class = "slider-container",
                  div(class = "slider-left", "Independently (I)"),
                  div(class = "slider-center", sliderInput("ei3", label = NULL, min = 1, max = 10, value = 5)),
                  div(class = "slider-right", "Brainstorming with others (E)")
              )
            ),
            
            card(
              class = "tall-card",
              card_header(
                span(
                  tagList(
                    icon("envelope"),
                    "Communication Focus"
                  ),
                  style = "color: #50e3c2; font-weight: bold; font-size: 16px;"
                )
              ),
              h4("In a conversation, are you more focused on the present and current details or on future possibilities and patterns?"),
              div(class = "slider-container",
                  div(class = "slider-left", "Future possibilities and patterns (N)"),
                  div(class = "slider-center", sliderInput("ns3", label = NULL, min = 1, max = 10, value = 5, step = 1)),
                  div(class = "slider-right", "Present and current details (S)")
              )
            ),
            
            card(
              class = "tall-card",
              card_header(
                span(
                  tagList(
                    icon("check-circle"),
                    "Decision Making Style"
                  ),
                  style = "color: #50e3c2; font-weight: bold; font-size: 16px;"
                )
              ),
              h4("When faced with a problem, do you rely more on your head and reason or your heart and empathy??"),
              div(class = "slider-container",
                  div(class = "slider-left", "Heart and empathy (F)"),
                  div(class = "slider-center", sliderInput("ft3", label = NULL, min = 1, max = 10, value = 5, step = 1)),
                  div(class = "slider-right", "Head and reason (T)")
              )
            ),
            
            card(
              class = "tall-card",
              card_header(
                span(
                  tagList(
                    icon("calendar-check"),
                    "Deadline Management"
                  ),
                  style = "color: #50e3c2; font-weight: bold; font-size: 16px;"
                )
              ),
              h4("How do you approach deadlines??"),
              div(class = "slider-container",
                  div(class = "slider-left", "Tend to work better under pressure and close to the deadline (P)"),
                  div(class = "slider-center", sliderInput("pj3", label = NULL, min = 1, max = 10, value = 5, step = 1)),
                  div(class = "slider-right", "Work diligently to meet deadlines well in advance (J)")
              )
            ),
            
            card(
              class = "tall-card",
              card_header(
                span(
                  tagList(
                    icon("user-friends"),
                    "Social Energy Preference"
                  ),
                  style = "color: #50e3c2; font-weight: bold; font-size: 16px;"
                )
              ),
              h4("In your free time, do you find yourself seeking out social events and gatherings or enjoying quieter activities at home??"),
              div(class = "slider-container",
                  div(class = "slider-left", "Quieter activities at home (I)"),
                  div(class = "slider-center", sliderInput("ei4", label = NULL, min = 1, max = 10, value = 5, step = 1)),
                  div(class = "slider-right", "Social events and gatherings (E)")
              )
            ),
            
            card(
              class = "tall-card",
              card_header(
                span(
                  tagList(
                    icon("sticky-note"),
                    "Planning Style"
                  ),
                  style = "color: #50e3c2; font-weight: bold; font-size: 16px;"
                )
              ),
              h4("When planning a trip, do you prefer to have a detailed itinerary and clear schedule or leave room for spontaneous experiences and changes??"),
              div(class = "slider-container",
                  div(class = "slider-left", "Leave room for spontaneous experiences and changes (N)"),
                  div(class = "slider-center", sliderInput("ns4", label = NULL, min = 1, max = 10, value = 5, step = 1)),
                  div(class = "slider-right", "Detailed itinerary and clear schedule (S)")
              )
            ),
            
            card(
              class = "tall-card",
              card_header(
                span(
                  tagList(
                    icon("project-diagram"),
                    "Task Prioritization Strategy"
                  ),
                  style = "color: #50e3c2; font-weight: bold; font-size: 16px;"
                )
              ),
              h4("How do you prioritize tasks and responsibilities??"),
              div(class = "slider-container",
                  div(class = "slider-left", "Considering the values and impact on people (F)"),
                  div(class = "slider-center", sliderInput("ft4", label = NULL, min = 1, max = 10, value = 5, step = 1)),
                  div(class = "slider-right", "Based on logical importance and efficiency (T)")
              )
            ),
            
            card(
              class = "tall-card",
              card_header(
                span(
                  tagList(
                    icon("desktop"),
                    "Workspace Organization Preference"
                  ),
                  style = "color: #50e3c2; font-weight: bold; font-size: 16px;"
                )
              ),
              h4("In a work setting, do you prefer a clear and organized workspace or are you comfortable with a more flexible and adaptable environment??"),
              div(class = "slider-container",
                  div(class = "slider-left", "Comfortable with a more flexible and adaptable environment (P)"),
                  div(class = "slider-center", sliderInput("pj4", label = NULL, min = 1, max = 10, value = 5, step = 1)),
                  div(class = "slider-right", "Prefer a clear and organized workspace (J)")
              )
            ),
            
            card(
              class = "tall-card",
              card_header(
                span(
                  tagList(
                    icon("comments"),
                    "Communication Comfort Level"
                  ),
                  style = "color: #50e3c2; font-weight: bold; font-size: 16px;"
                )
              ),
              h4("How do you feel about small talk??"),
              div(class = "slider-container",
                  div(class = "slider-left", "Find it somewhat awkward or draining (I)"),
                  div(class = "slider-center", sliderInput("ei5", label = NULL, min = 1, max = 10, value = 5, step = 1)),
                  div(class = "slider-right", "Enjoy it and find it easy to engage in (E)")
              )
            ),
            
            card(
              class = "tall-card",
              card_header(
                span(
                  tagList(
                    icon("info-circle"),
                    "Information Processing Style"
                  ),
                  style = "color: #50e3c2; font-weight: bold; font-size: 16px;"
                )
              ),
              h4("How do you make decisions??"),
              div(class = "slider-container",
                  div(class = "slider-left", "Consider potential outcomes and future possibilities (N)"),
                  div(class = "slider-center", sliderInput("ns5", label = NULL, min = 1, max = 10, value = 5, step = 1)),
                  div(class = "slider-right", "Based on practical considerations and real-world implications (S)")
              )
            ),
            
            card(
              class = "tall-card",
              card_header(
                span(
                  tagList(
                    icon("users-cog"),
                    "Group Decision-Making Approach"
                  ),
                  style = "color: #50e3c2; font-weight: bold; font-size: 16px;"
                )
              ),
              h4("In a group decision-making process, do you tend to advocate for the most logical and rational choice or the one that aligns with personal values and harmony??"),
              div(class = "slider-container",
                  div(class = "slider-left", "Aligns with personal values and harmony (F)"),
                  div(class = "slider-center", sliderInput("ft5", label = NULL, min = 1, max = 10, value = 5, step = 1)),
                  div(class = "slider-right", "Logical and rational choice (T)")
              )
            ),
            
            card(
              class = "tall-card",
              card_header(
                span(
                  tagList(
                    icon("broom"),
                    "Workspace Organization Preference"
                  ),
                  style = "color: #50e3c2; font-weight: bold; font-size: 16px;"
                )
              ),
              h4("In a work setting, do you prefer a clear and organized workspace or are you comfortable with a more flexible and adaptable environment??"),
              div(class = "slider-container",
                  div(class = "slider-left", "Pack on the fly, throwing in what feels right (P)"),
                  div(class = "slider-center", sliderInput("pj5", label = NULL, min = 1, max = 10, value = 5, step = 1)),
                  div(class = "slider-right", "Plan and make a checklist in advance (J)")
              )
            ),
            
            card(
              class = "tall-card",
              card_header(
                span(
                  tagList(
                    icon("users-cog"),
                    "Decision-Making Input Style"
                  ),
                  style = "color: #50e3c2; font-weight: bold; font-size: 16px;"
                )
              ),
              h4("When making decisions, do you rely more on your own instincts and feelings or seek input from others??"),
              div(class = "slider-container",
                  div(class = "slider-left", "Rely on own instincts and feelings (I)"),
                  div(class = "slider-center", sliderInput("ei6", label = NULL, min = 1, max = 10, value = 5, step = 1)),
                  div(class = "slider-right", "Seek input from others (E)")
              )
            ),
            
            card(
              class = "tall-card",
              card_header(
                span(
                  tagList(
                    icon("bullseye"),
                    "Task Focus vs. Big Picture Thinking"
                  ),
                  style = "color: #50e3c2; font-weight: bold; font-size: 16px;"
                )
              ),
              h4("When working on a project, do you tend to focus on the specific tasks at hand or the overall vision and goals??"),
              div(class = "slider-container",
                  div(class = "slider-left", "Overall vision and goals (N)"),
                  div(class = "slider-center", sliderInput("ns6", label = NULL, min = 1, max = 10, value = 5, step = 1)),
                  div(class = "slider-right", "Specific tasks at hand (S)")
              )
            ),
            
            card(
              class = "tall-card",
              card_header(
                span(
                  tagList(
                    icon("microphone"),
                    "Feedback Delivery Style"
                  ),
                  style = "color: #50e3c2; font-weight: bold; font-size: 16px;"
                )
              ),
              h4("When giving feedback, do you focus on providing objective analysis or consider the individual's feelings and emotional response??"),
              div(class = "slider-container",
                  div(class = "slider-left", "Consider the individual's feelings and emotional response (F)"),
                  div(class = "slider-center", sliderInput("ft6", label = NULL, min = 1, max = 10, value = 5, step = 1)),
                  div(class = "slider-right", "Objective analysis (T)")
              )
            ),
            
            card(
              class = "tall-card",
              card_header(
                span(
                  tagList(
                    icon("sync"),
                    "Reaction to Change"
                  ),
                  style = "color: #50e3c2; font-weight: bold; font-size: 16px;"
                )
              ),
              h4("What do you do when your plans suddenly change??"),
              div(class = "slider-container",
                  div(class = "slider-left", "Pack on the fly, throwing in what feels right (P)"),
                  div(class = "slider-center", sliderInput("pj6", label = NULL, min = 1, max = 10, value = 5, step = 1)),
                  div(class = "slider-right", "Plan and make a checklist in advance (J)")
              )
            ),
            card(
              class = "tall-card",
              card_header(
                span(
                  tagList(
                    icon("seedling"),
                    "Adaptability to Novelty"
                  ),
                  style = "color: #50e3c2; font-weight: bold; font-size: 16px;"
                )
              ),
              h4("How do you handle new and unfamiliar situations??"),
              div(class = "slider-container",
                  div(class = "slider-left", "Approach them with caution (I)"),
                  div(class = "slider-center", sliderInput("ei7", label = NULL, min = 1, max = 10, value = 5, step = 1)),
                  div(class = "slider-right", "Embrace them with enthusiasm (E)")
              )
            ),
            
            card(
              class = "tall-card",
              card_header(
                span(
                  tagList(
                    icon("users-cog"),
                    "Discussionn Contribution Style"
                  ),
                  style = "color: #50e3c2; font-weight: bold; font-size: 16px;"
                )
              ),
              h4("In a group discussion, do you prefer to stick to the facts and details or contribute ideas and theories??"),
              div(class = "slider-container",
                  div(class = "slider-left", "Contribute ideas and theories (N)"),
                  div(class = "slider-center", sliderInput("ns7", label = NULL, min = 1, max = 10, value = 5, step = 1)),
                  div(class = "slider-right", "Stick to facts and details (S)")
              )
            ),
            
            card(
              class = "tall-card",
              card_header(
                span(
                  tagList(
                    icon("frown"),
                    "Expression in Conflict"
                  ),
                  style = "color: #50e3c2; font-weight: bold; font-size: 16px;"
                )
              ),
              h4("How do you express your opinions in a debate or discussion??"),
              div(class = "slider-container",
                  div(class = "slider-left", "Consider the emotional needs and harmony of individuals involved (F)"),
                  div(class = "slider-center", sliderInput("ft7", label = NULL, min = 1, max = 10, value = 5, step = 1)),
                  div(class = "slider-right", "Focus on finding logical solutions and compromises (T)")
              )
            ),
            
            card(
              class = "tall-card",
              card_header(
                span(
                  tagList(
                    icon("sitemap"),
                    "Decision-Making Structure Preference"
                  ),
                  style = "color: #50e3c2; font-weight: bold; font-size: 16px;"
                )
              ),
              h4("When faced with a new opportunity, do you prefer to consider the advantages and disadvantages prior to making a decision or go with the flow and see where it takes you??"),
              div(class = "slider-container",
                  div(class = "slider-left", "Go with the flow and see where it takes you (P)"),
                  div(class = "slider-center", sliderInput("pj7", label = NULL, min = 1, max = 10, value = 5, step = 1)),
                  div(class = "slider-right", "Consider the advantages and disadvantages prior to deciding (J)")
              )
            )
          )
        ),
        
        nav_panel(
          title = "Results",
          uiOutput("results_panel")
        ),
        
        nav_panel(
          title = "Personality DataBase",
          uiOutput("results_panel1")
        ),
        
        nav_panel(
          title = "Meet the Team",
          div(
            style = "padding: 20px;",
            
            div(
              style = "display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px;",
              div(
                h1("MEET THE DEVELOPERS", style = "font-size: 2.5rem; font-weight: bold; margin-bottom: 0.5rem;"),
                h1("THE TEAM BEHIND THE PROJECT", style = "font-size: 2.5rem; font-weight: bold; margin-bottom: 2rem;")
              ),
              
              div(
                style = "text-align: center;",
                icon("users-cog", class = "fa-2x", style = "color: #50e3c2;margin-bottom: 2.5rem;font-size: 5rem;")
              )
            ),
            
            div(
              style = "margin-top: 40px;",
              
              fluidRow(
                column(
                  width = 4,
                  div(
                    class = "card tall-card",
                    style = "height: 100%;",
                    # div(
                    #   class = "card-header",
                    #   h3("Developer One", style = "text-align: center; margin: 0;")
                    # ),
                    div(
                      style = "padding: 20px; text-align: center;",
                      div(
                        img(src = "K.png", alt = "Developer One",
                            style = "max-width: 200px; height: auto; border-radius: 50%; margin-bottom: 20px;")
                      ),
                      h4("Kavina", style = "color: #FFD166; margin-top: 0;"),
                      p("Data detective by day, dashboard dreamer by night.", 
                        style = "color: #e0e0e0;")
                    )
                  )
                ),
                
                column(
                  width = 4,
                  div(
                    class = "card tall-card",
                    style = "height: 100%;",
                    # div(
                    #   class = "card-header",
                    #   h3("Developer Two", style = "text-align: center; margin: 0;")
                    # ),
                    div(
                      style = "padding: 20px; text-align: center;",
                      div(
                        img(src = "D.jpg", alt = "Developer Two",
                            style = "max-width: 200px; height: auto; border-radius: 50%; margin-bottom: 20px;")
                      ),
                      h4("Dharani", style = "color: #00A550; margin-top: 0;"),
                      p("Lover of theory over practice any day but if modeling shows up, it will be addressed.",
                        style = "color: #e0e0e0;")
                    )
                  )
                ),
                
                column(
                  width = 4,
                  div(
                    class = "card tall-card",
                    style = "height: 100%;",
                    # div(
                    #   class = "card-header",
                    #   h3("Developer Three", style = "text-align: center; margin: 0;")
                    # ),
                    div(
                      style = "padding: 20px; text-align: center;",
                      div(
                        img(src = "A.jpg", alt = "Developer Three",
                            style = "max-width: 200px; height: auto; border-radius: 50%; margin-bottom: 20px;")
                      ),
                      h4("Anupama", style = "color: #89CFF0; margin-top: 0;"),
                      p("Loves a good tune,a great show, and dreaming of the next trip",
                        style = "color: #e0e0e0;")
                    )
                  )
                )
              ),
              
              div(
                style = "text-align: center; margin-top: 40px; background-color: #1a1a1a; border-radius: 10px; padding: 30px;",
                h3(class="gradient-text",
                  "Our Mission", style = "margin-top: 0;"),
                p(class="gradient-text",
                  "Assisting You to Understand Your Self Better in a More Fun Manner",
                  style = "margin-bottom: 20px;")
                #,
                # 
                # actionButton("contact_team", "CONTACT US",
                #              style = "background-color: #50e3c2; color: #000000; border: none; border-radius: 50px; padding: 15px 60px; font-size: 1.2rem; font-weight: bold; cursor: pointer; transition: all 0.3s ease; margin-top: 10px;")
              )
            )
          )
        ),
        nav_panel(
          title = "Privacy Policy",
          div(
            style = "padding: 30px; max-width: 960px; margin: 0 auto;",
            
            div(
              style = "display: flex; align-items: center; gap: 20px; margin-bottom: 35px;",
              icon("shield-alt", class = "fa-3x", style = "color: #50e3c2;"),
              h1("Privacy Policy", style = "font-size: 3rem; font-weight: bold; margin: 0; color: white;")
            ),
            
            div(
              style = "background-color: rgba(30, 30, 30, 0.95); border-radius: 12px; padding: 35px; margin-bottom: 40px;",
              
              h3("Our Commitment to Your Privacy", style = "color: #50e3c2; font-size: 1.7rem; margin-top: 0;"),
              
              p("At YouNiverse, we believe your journey of self-discovery should be both enlightening and secure. 
      We are committed to protecting your personal information and ensuring you maintain control over your data.", 
                style = "color: #ffffff; line-height: 1.9; font-size: 18px;"),
              
              h3("Information We Collect", style = "color: #50e3c2; font-size: 1.7rem; margin-top: 35px;"),
              
              p("When you use TypeQuest, we collect:", style = "color: #ffffff; line-height: 1.9; font-size: 18px;"),
              
              tags$ul(
                style = "color: #e0e0e0; line-height: 2; font-size: 18px;",
                tags$li("Your responses to personality assessment questions"),
                tags$li("Your calculated personality profile and type"),
                tags$li("Basic usage data to improve your experience")
              ),
              
              h3("How We Use Your Information", style = "color: #50e3c2; font-size: 1.7rem; margin-top: 35px;"),
              
              p("Your information is used exclusively to:", style = "color: #ffffff; line-height: 1.9; font-size: 18px;"),
              
              tags$ul(
                style = "color: #e0e0e0; line-height: 2; font-size: 18px;",
                tags$li("Generate your personalized personality profile"),
                tags$li("Provide tailored insights based on your type"),
                tags$li("Improve our personality assessment algorithms"),
                tags$li("Enhance the overall app experience")
              ),
              
              div(
                style = "background-color: rgba(80, 227, 194, 0.1); border-left: 5px solid #50e3c2; padding: 20px; margin: 30px 0;",
                p(HTML("<strong style='color: #50e3c2;'>Our Promise:</strong> We will never sell, rent, or share your personal information with third parties for marketing purposes."), 
                  style = "color: #ffffff; margin: 0; line-height: 1.8; font-size: 18px;")
              ),
              
              h3("Data Security", style = "color: #50e3c2; font-size: 1.7rem; margin-top: 35px;"),
              
              p("We implement robust security measures to protect your information:", 
                style = "color: #ffffff; line-height: 1.9; font-size: 18px;"),
              
              tags$ul(
                style = "color: #e0e0e0; line-height: 2; font-size: 18px;",
                tags$li("Industry-standard encryption for all data transmissions"),
                tags$li("Secure storage systems with limited access"),
                tags$li("Regular security audits and updates")
              ),
              
              h3("Your Rights", style = "color: #50e3c2; font-size: 1.7rem; margin-top: 35px;"),
              
              p("You maintain control over your data. You can:", 
                style = "color: #ffffff; line-height: 1.9; font-size: 18px;"),
              
              tags$ul(
                style = "color: #e0e0e0; line-height: 2; font-size: 18px;",
                tags$li("Access your stored information at any time"),
                tags$li("Request deletion of your data"),
                tags$li("Opt out of non-essential data collection")
              ),
              
              h3("Contact Us", style = "color: #50e3c2; font-size: 1.7rem; margin-top: 35px;"),
              
              p("If you have questions about our privacy practices or would like to exercise your data rights, please contact our privacy team:", 
                style = "color: #ffffff; line-height: 1.9; font-size: 18px;"),
              
              div(
                style = "background-color: rgba(20, 20, 20, 0.9); border-radius: 8px; padding: 20px; margin-top: 20px;",
                p(HTML("Email: <span style='color: #50e3c2;'>privacy@youniverse-app.com</span>"), 
                  style = "color: #ffffff; margin: 5px 0; font-size: 18px;"),
                p(HTML("Form: <span style='color: #50e3c2;'>www.youniverse-app.com/contact</span>"), 
                  style = "color: #ffffff; margin: 5px 0; font-size: 18px;")
              )
            ),
            
            div(
              style = "text-align: center; color: #c5c6c7; font-size: 15px; margin-top: 50px;",
              p("Last updated: April 2025"),
              p("YouNiverse TypeQuest — Exploring the cosmos of You while respecting your privacy")
            )
          )
        )
      )
    )
  )
)

server <- function(input, output, session) {
  showMain <- reactiveVal(FALSE)
  
  observeEvent(input$enterButton, {
    showMain(TRUE)
  })
  
  output$showMainContent <- reactive({
    showMain()
  })
  outputOptions(output, "showMainContent", suspendWhenHidden = FALSE)
  
  model <- readRDS("bestModel.RDS")
  
  rw_data <- read.csv("www/rw_data.csv",sep = ',')
  rw_data[, c(2,3,8,9)] <- lapply(rw_data[, c(2,3,8,9)], as.factor)
  rw_data <- as.data.frame(rw_data)
  summary(rw_data)
  
  
  personality_data <- list(
    "ISTJ" = "The ISTJ personality type is Introvert, Sensing, Thinking, and Judging, which means they are practical, detail-oriented, and highly dependable. As one of the 16 personality types in the MBTI framework, ISTJs excel in creating order and structure, valuing tradition, and adhering to rules and procedures. Their logical and methodical approach makes them reliable and efficient, often thriving in environments that require precision and consistency.

ISTJs are honest and responsible. People can count on their word, dependability, and long-term commitment, even during tough times. They will pay attention to and attend to your needs, bringing you the things that make you smile. You can count on them to do things the right way and cautiously, evaluating all facts and details. They may seem serious and wise on the surface, but deep down, they have a quirky and lovable sense of humor.

These individuals are hard workers people can rely on to follow through on tasks. They see that everything is planned and fixed, from brainstorming to implementation. ISTJs enjoy authority over things because they are perfectionists and want everything to be up to a certain standard. Because of this, they may take for granted other people’s efforts and their own. They are not big fans of giving themselves credit because; they are merely doing their obligation. As people with a strong sense of duty and responsibility, ISTJs never second guess in taking complete accountability for their actions.

ISTJs are a “slowly but surely” type of person. Typically, they work long hours and put a lot of effort into tasks given to them. They attend to every detail meticulously. ISTJs spend a lot of their time making sure that they deliver nothing but the best. They take pride in what they do. ISTJs have great focus, especially when it comes to doing essential tasks. Their unique capability is to ignore all the distractions that may come their way. They are hard workers and often expect everybody to do the same. They dislike inefficient people and those who leave out essential details when working.

One of ISTJs' biggest desires is the recognition of society’s established norms and institutions. They will guard and protect traditions and culture from the past. ISTJs thrive in a life where there is order. Because of this belief, ISTJs are people who like planning and following certain routines, whether in their lives or their view of the world.

You can trust an ISTJ to hold on to their promises. They are responsible and realistic at the same time. When ISTJs say something, they mean it and will work their best to achieve it. Although, sometimes, they may have difficulty passing on favors or be stubborn. This may lead to them being taken advantage of or hardwired to what they believe in. Often, ISTJs can’t accept when they are wrong.", 
    "ISFJ" = "ISFJ stands for Introvert, Sensing, Feeling, and Judging, making up one of the 16 personality types in the MBTI framework. Known as the Protector, ISFJs are characterized by their dedication to duty, warm-heartedness, and meticulous attention to detail. They thrive in environments where they can provide practical support and ensure stability, valuing tradition and loyalty. This personality type excels in creating harmonious spaces and is deeply committed to the well-being of their loved ones, making them reliable and compassionate friends and partners.

ISFJs are supportive, reliable, and patient and are always available to help the people around them. A deep and unwavering devotion to protecting their loved ones is underneath their warm and selfless demeanor. They're humble and altruistic people who underplay their accomplishments and take their responsibilities seriously. They have many redeeming qualities that their many friends love.

Warm and kind-hearted, ISFJs live with compassion, integrity, and practical kindness. They are good at keeping harmony. ISFJs are polite and generous individuals. For them, people should pay generosity with even more generosity. They are also conscious of others. They make sure that they feel seen, recognized, and appreciated.

ISFJs are attached to familiarity. They find comfort in knowing that things have been done and tested in the past. Because of this, they are great bearers of traditions and rules. ISFJs believe that systems exist because they have a purpose. Often, it is hard for ISFJs to break out from a pattern or from what they've been used to. ISFJs would rather stick to familiarity than take risks. They are usually hesitant to change in the absence of concrete evidence.

If there were people who would remember all the essential things, such as deadlines and special occasions, they would be the ISFJs. They are careful planners and observant of their surroundings. Their great memory and thoroughness aid in their dedication and thoughtfulness.

Naturally private and sensitive, ISFJs are likely to keep their feelings to themselves until they can't. ISFJs may struggle to separate their personal lives from their professional ones. They are good at sensing how other people feel, but when it comes to their own, that is not the case. ISFJs take everything emotionally. They may try to put on a brave face when with others, but deal with the hurt when back home.", 
    "INFJ" = "INFJ is a personality type with Introvert, Intuitive, Feeling, and Judging traits, making them one of the 16 personality types in the MBTI framework. Known for their deep empathy and strong sense of idealism, INFJs are often seen as insightful and compassionate individuals who seek meaningful connections. They excel at understanding others' emotions and are driven by a desire to make a positive impact on the world. As natural protectors, INFJs are dedicated to helping others and often pursue careers that align with their values and vision for a better future.

INFJs are principled, generous, and talented communicators. They hold a passion for doing good for the world and for the people they love, driven by their deeply held principles and values. They are one of the most loyal, loving, and supportive partners. They are visionary and see the world as what could be, and are continually drawing insights that explain how people and the universe work. But at the same time, you'll find them adorable and endearing as they could be doing this while bumping into things or forgetting to wear matching socks.

Known to be artistic and creative, INFJs have overflowing ideas and imagination. They translate their ideals into different art forms where there could be layers of hidden meanings and possibilities. Their minds are truly creative dens.

INFJs have the potential to be better at handling other people's emotions than their own. Most of the time, they have no control over their feelings. Because of this, they are naturally gentle and don't want to hurt anyone. They are conflict-averse and sensitive to problems and tend to internalize them even days after.

Being the rarest personality type in the world, INFJs often feel like they are aliens living on earth. Because of this, they are often misunderstood. INFJs don't like fitting in or compromising their ideals. They have strong, uncompromising morals and always act based on what they believe is right. Even as true introverts, INFJs could be mistaken as extroverts because they can also be social chameleons. They can blend into social gatherings because of their inviting attitude and ability to get along well with others.

INFJs see to it that they find opportunities wherein they can step in and speak up. They crave moments where they can make a difference. For this personality type, success is not measured by tangible achievements but rather by fulfillment, altruism, and good done in service of the world. As people who care deeply about integrity, they won't stop until they can fix problems in society. With INFJs' creativity, imagination, and sensitivity, they seek to uplift others and share compassion for others.

", 
    "INTJ" = "The INTJ personality type stands for Introvert, Intuitive, Thinking, and Judging, making them one of the 16 personality types in the MBTI framework. Known for their strategic thinking, analytical skills, and independent nature, INTJs excel in planning and problem-solving. They are visionaries who thrive on setting long-term goals and devising innovative solutions, often demonstrating a high degree of self-confidence and ambition.

INTJs are strategic and intuitive thinkers and thorough planners. They exude a quiet confidence, intellectual insight, and knowledge. They are usually nonconformists who don't mind being different from the crowd, thinking for themselves, and rejecting long-standing traditions or rules that make no logical sense. They might intimidate you at first; they may appear intense and aloof. They don't come across as needy, and even the pretty opposite, fiercely independent.

People with INTJ personalities don't settle with the knowledge fed to them at school or by books. They genuinely want to learn more and continuously expand their knowledge by trying to understand everything about the world. They savor the sensation of whole immersion into their studies and can easily spend hours doing informational research. INTJs are insightful and quick to absorb new information.

INTJs thrive in a world of ideas and strategic planning. 'Supreme strategists' are what they are often known for. Whenever they encounter anything, ideas and concepts run through their minds on how to turn it into a rational system. They are like this because they generally dislike messiness or inefficiency.

However, INTJs are not the greatest in dealing with people or building relationships. They often have little to no interest in other people's thoughts or feelings. For INTJs, what's most important are intelligence, knowledge, and competence. Consequently, they may sometimes appear arrogant or elitist. They are most commonly drawn to contrary viewpoints and tend to express their judgment, even if it may come off as impolite or rude. INTJs do not do well in expressing their ideas. This is one reason why they are commonly misunderstood. But beneath their cold exterior is a deeply emotional person, but just as profoundly loathes to express it until you’ve already built a very close relationship.

For INTJs, practicality is the best way to go about things. They dislike waiting for others to catch up because they know they don't need them. Most often than not, they want to make decisions by themselves. They don't want to be influenced by the status quo or anyone else. They believe that when they want something to be perfectly done, they should do it by themselves.", 
    "ISTP" = "ISTP is a personality type with Introvert, Sensing, Thinking, and Perceiving traits, making them practical, observant, logical, and adaptable. As one of the 16 personality types in the MBTI framework, ISTPs excel in hands-on activities and problem-solving, often thriving in environments that require quick thinking and action. Known for their independence and resourcefulness, ISTPs enjoy exploring new experiences and mastering various skills, making them versatile and innovative individuals.

ISTPs are cheerful, relaxed, and go with the flow personalities with great common sense and are skilled with their hands and tools. They are laid-back yet rebellious, intellectual, but chill. They are independent, self-sufficient, and far from clingy or desperate. Fluent in sarcasm, they kind of enjoy it when people can't tell if they're joking or actually serious.

As rational and logical people, ISTPs aim to understand how things work. Typically, ISTPs are emotionally detached because they don't want their feelings to affect their decisions. They value results and actions over how other people would feel. They value logic and efficiency greatly and thus don't like talking much, especially about unimportant things. ISTPs are individuals with a great sense of practicality. They have a high focus and self-discipline regarding things they deem essential.

ISTPs often have a unique ability in repairs and making things work again. They find happiness in tasks that require them to apply their logical skills and knowledge to analyze technicalities. ISTPs can see through every detail. They like taking things apart and checking if each part is working perfectly for the whole. The technical skills of ISTPs are unquestionable; they are great with tools and are exceptional at craftsmanship.

Their various natural capabilities and skills in many different areas make ISTPs great at adapting to change. They often get bored with routines, and find planning and preparing for things before they happen highly stressful. They generally dislike being mandated and regulated. ISTPs thrive when they are allowed to work at their own pace. However, since they are adaptable individuals, ISTPs can adjust their mindset to fit into circumstances that need them. They can even compromise and collaborate with others when that is what the world demands from them.

ISTPs are some of the most reliable when it comes to crises or emergencies. Their logical minds allow them to troubleshoot problems and tie loose ends faster than anyone else. ISTPs strive to come up with practical answers to the issues they encounter, interested in cause and effect relationships. Through that, they will be able to see where the problem came from, and they'll be able to solve it from there. This method will solve the current situation and prevent it from happening again.", 
    "ISFP" = "The ISFP personality type stands for Introvert, Sensing, Feeling, and Perceiving, making them one of the 16 personality types identified by the MBTI. ISFPs are known for their deep appreciation of beauty, strong connection to their emotions, and a spontaneous, flexible approach to life. They thrive in environments where they can express their creativity and are often seen as gentle, compassionate, and attentive to the present moment. This unique blend of traits makes ISFPs highly attuned to the world around them, enabling them to form meaningful connections with others while remaining true to their artistic inclinations.

ISFPs are creative, artistic, and spontaneous souls. They are fiercely individualistic and pride themselves on being outside the box and crushing labels and stereotypes. They are a mix of contradictions: empathetic yet mysterious, reserved but bold, and sensitive yet adventurous. They have a natural talent for aesthetics and know how to look good.

As flexible and spontaneous individuals, ISFPs like to keep their options open. They ensure that they are leaving ample space for adventures and the unexpected. ISFPs see life as a sensation of possibilities, upsetting society’s expectations along the way. Because explorations and experiments are some of their greatest energizers, they tend to get involved in risky things.

ISFPs are sensitive souls who are graceful, gentle, and typically soft-spoken. They are tolerant and accepting people who appreciate life as it is. Every encounter they've had holds a special place in their hearts. ISFPs always seem to consider compassion and consideration. Because of their ability to pick up even the unspoken, they know that they shouldn't judge other people. ISFPs decide based on their own subjective belief and believe in second chances.

For ISFPs, actions are louder than words. They believe the best way to learn is to get their hands dirty with practical applications. Sitting in the corner and reading thick books with tons of abstract ideas and theories don't work for them. ISFPs are realistic dreamers who can balance creativity and logic. Because of their logical side, they can see patterns and look for opportunities for change.

Creative and free-spirited, ISFPs are natural artists. They are attracted to beauty and typically have a strong appreciation for aesthetics. They have vivid imaginations, which they use to create different works of art. They dance to their own rhythm, doing the things they find beautiful.", 
    "INFP" = "INFP stands for Introvert, Intuitive, Feeling, and Perceiving, making them one of the 16 personality types in the MBTI. INFPs are introspective and empathetic, often driven by a strong sense of idealism and morality. They are deeply in tune with their own emotions as well as those of others, which makes them compassionate and understanding friends and partners. Known for their creativity and open-mindedness, INFPs are often drawn to artistic pursuits and value authenticity in their relationships.

INFPs are optimists, always looking for the good in people, even in the worst situations. They're accepting, open-minded, imaginative, and spiritual. They are guided by their inner moral compass and the desire to do right by their values. They desire a life of meaning, personal significance, and individual expression.

Overly idealistic, INFPs often daydream and fantasize rather than take actual action. They look for the 'what could be' instead of focusing on the 'what is' INFPs are creative and imaginative; they have a childlike inner world that is vast, lush, and filled with magical transformative possibilities. They tend to disappoint themselves. After all, they are idealistic because they want to see what they have in mind in the real world, which is often not the case.

INFPs like dealing with things based on how they feel about them. They have their personal values system where they decide based on their emotions instead of what is right. They generally dislike details, but they are willing to compromise if it is for their cause. INFPs would lean into seeing the bigger picture instead of going through the little details. Because of this, they don't like dealing with hard facts and logic.

Many people may not understand their uniqueness but they are okay with that and enjoy it. They have no intention of pretending to be somebody else. INFPs are committed to authenticity, and because of that, they often look for opportunities where they can fully express themselves. They are some of the most open-minded and open-hearted people, but deep inside, they tend to be too hard on themselves.

Despite being introverts, INFPs are adventurous. For them, adventures and new experiences are opportunities to learn more about themselves, the world, and their purpose. As long as the adventures stimulate what they believe in and live for, they are always ready to take a chance. They think that these adventures are part of their path.", 
    "INTP" = "INTP is a personality type with Introvert, Intuitive, Thinking, and Perceiving traits, meaning they are analytical, open-minded, and intellectually curious. As one of the 16 personality types in the MBTI framework, INTPs excel in logical reasoning and abstract thinking, often thriving in environments that challenge their problem-solving skills. This personality type values independence and creativity, making them innovative thinkers who enjoy exploring theoretical concepts and complex ideas.

INTPs are quintessential philosophers and independent thinkers. They are logical, objective, open-minded, imaginative, original, honest, and low maintenance. INTPs are addicted to new information and a never-ending search for truth. Not often one to sugarcoat things, they can sometimes leave conversations with awkward silences, but you can count on their honesty. But beneath their aura of intellect and busy mind is an intensely loving and loyal heart.

INTPs like to relay their ideas and thoughts with no filter, which is why they are often misunderstood. They like being straightforward and upfront because, for them, being upfront isn't rude but rather a point of pride. Being direct can avoid misunderstandings, and time could be saved and put to more practical use. They might come off cold, mysterious, and hard to pin down, but they want to offer emotional support to people close to them; the problem is, they don't know how. Most of the time, they dismiss subjectivity and are often clueless in emotional situations.

They value knowledge more than anything else. INTPs find joy in observing and theorizing about everything they see around them. They try to find the meaning behind things. As a result, they often impress others with their unique perspective. Behind their calm exterior, they are very passionate about reason, analysis, and innovation. The mind of an INTP is fascinating because they perceive the world as a vast machine made up of numerous parts that all seem to fit together.

As introverts, they prefer being by themselves, reflecting on how things function, and formulating solutions to issues. Behind an INTP's introverted personality is a vibrant inner world where they can pay attention to their inner thoughts rather than the outside environment. They enjoy time alone; thinking in silence for them is equivalent to extroverts' going out to parties.", 
    "ESTP" = "ESTP (Rebel) stands for Extraverted, Sensing, Thinking, and Perceiving, making them one of the 16 personality types in the MBTI framework. Known for their spontaneity, adaptability, and love for excitement, ESTPs thrive in dynamic environments where they can take risks and live in the moment. This personality type is often seen as energetic, resourceful, and action-oriented, making them natural problem-solvers who excel in crisis situations. If you're looking for a friend or partner who embodies the spirit of adventure and practicality, the ESTP personality type might be your perfect match.

ESTPs are bold, direct, and entrepreneurial. They are the life of the party and live for adventure and a bit of danger. They are the quintessential bad boy or bad girl, charming with good humor and confidence. They are good at knowing how others are feeling and what they need. In crises where others panic, they face straight on.

Often impatient with theories, ESTPs prefer practical facts rather than abstract ideas. For them, views only bear little importance to life. ESTPs often have problems in school because of this belief. Quick with decision-making, ESTPs solely base them on logical reasons and innovative solutions.

With their casual approach to life, ESTPs are often regarded as street-smart. ESTPs see that their options are always open; this may be one reason they like improvising more than planning. ESTPs are versatile individuals who are great at conquering problems that are on hand. They are great at grasping their environment, making them a few steps ahead of other people at most times. ESTPs welcome and embrace new challenges wherever they are.

ESTPs are impulsive people. They often take risks even when it is not necessary. The 'leap before you look' personality is prominent with ESTPs. There are situations where they may be overly caught up in the moment and insensitive. ESTPs tend to act or speak before thinking because of their impulsiveness.

People can't expect ESTPs to slow down for them. They are fast-paced people; they like moving quickly and wish to skip life's serious and emotional parts. ESTPs are people of action who thrive in the physical environment. A lot of ESTPs are athletic and drawn to the physical lifestyle. They have kinesthetic intelligence and exceptional hand-eye coordination. They are some of the most coordinated people.", 
    "ESFP" = "The ESFP personality type is Extraverted, Sensing, Feeling, and Perceiving, making them the life of the party among the 16 personality types in the MBTI. Known for their vibrant energy and love for social interactions, ESFPs thrive in dynamic environments and are highly attuned to the present moment. They are empathetic, spontaneous, and often the center of attention, effortlessly drawing people in with their charisma and warmth.

ESFPs are the life of the party, and there's never a dull moment with them. They have great aesthetic tastes and people skills. People are drawn to them for their mix of charismatic social grace, enthusiastic warmth, and spontaneous adventure. They are masters of living in the moment, bringing joy and laughter to the people around them.

'Go where the water takes you' is something that ESFPs live by. They are flexible, adaptable, resourceful, and outgoing. ESFPs believe they can handle things as they happen because they dislike preparing for what could be. ESFPs believe in growing as they go.

ESFPs prefer following their own path and dislike people telling them which way they should go. As practical learners, ESFPs often have difficulty learning when trapped in a four-cornered room. For them, to learn is to experience.

Warm, sympathetic, and fun-loving, it is a given that people love ESFPs, and they love them too. They have a keen sense of seeing people behind who they are trying to be, but rather who they are. ESFPs accept everyone, despite being aware of who they are inside. For them, to accept others is to allow them to enjoy themselves. They care about other people's feelings; thus, they are always ready to extend help.

With their eye for beauty, ESFPs appreciate the finer things in life. They find happiness in having pretty things. ESFPs are known for being explorers of life's pleasures. Maybe that is why they always try and seek what it has to offer. ESFPs always follow the trends because of their strong sense of aesthetics. They are not just people and life-loving; they also adore material comforts.", 
    "ENFP" = "The ENFP personality type is Extravert, Intuitive, Feeling, and Perceiving, which means they are enthusiastic, imaginative, empathetic, and spontaneous. As one of the 16 personality types in the MBTI framework, ENFPs thrive in social settings, driven by their passion for new ideas and deep emotional connections. Their intuitive nature allows them to see possibilities where others see obstacles, making them excellent problem solvers and innovators. With a strong preference for flexibility and open-ended experiences, ENFPs bring a dynamic and adaptable energy to any situation.

ENFPs are free spirits: energetic, enthusiastic, and curious. Their engaging, warm personality is made even more endearing by their imagination and creativity. They are fiercely independent and enthused by the possibilities, the unknown, and the world yet discovered. They will stand up for their ideals and for the principles they believe in.

Some of the most versatile and talented among the personality types, ENFPs are bright people who are full of potential. They are typically drawn to creative endeavors, like art and cultural interpretations. Since they are some of the most skilled, they are highly adaptable to change too. ENFPs are great conversationalists masters of talking their way out of their many prior commitments.

ENFPs believe that everyone and everything is connected as if life is like a massive chain. They give an ample amount of time thinking about the possibilities that these connections might bring. The healthy balance of their imagination, creativity, and curiosity makes them who they are. ENFPs have great charm, ingenious ideas, and across-the-spectrum capabilities, making them independent and outgoing.

If there is one thing that ENFPs fear, it is boredom and stagnation. They don’t like it when they are mandated to do specific things at certain times. They don’t like trivial details and rules because those are not exciting. Enthusiasm is vital for ENFPs since it is their drive to function well. They can be highly passionate about things that they are excited about. Without it, they tend to become directionless and lacking in purpose.

ENFPs are optimistic people. They radiate warm and fun energy wherever they step in. The positive aura that they give off is also very contagious. They have a distinct ability to spark light into their own lives, even during their darkest moments. With their youthful attitude at heart, ENFPs inspire and bring out the best and beauty in life.",# 
    "ENTP" = "The ENTP personality type stands for Extraverted, Intuitive, Thinking, and Perceiving, making them one of the 16 personality types in the MBTI framework. Known as the Challenger, ENTPs are energetic, innovative, and quick-thinking individuals who thrive in dynamic environments. They excel at generating new ideas and love engaging in intellectual debates. With their charismatic and spontaneous nature, ENTPs are natural leaders who enjoy pushing boundaries and exploring new possibilities.

ENTPs are innovative, charming, and witty. Their quick and restless mental energy and enthusiasm about the future are contagious and attractive. Rebellious and brave, they aren't bound by rules and can be frequently found pushing the boundaries, challenging traditions, and blazing their path. They've got humor, brains, and imagination. They may forget the little things in life, but their passion and excitement for the future make us realize those details don't matter much.

For ENTPs, there is always a solution to every problem. Innovative, clever, and expressive, they are often labeled as logical powerhouses. Mapping out complex ideas and analyzing are some things that they generally like. Understanding and influencing other people are some of the things that ENTPs particularly like doing. They believe in their capabilities and are not afraid to utilize them at any time.

If other people can see things the way ENTPs do, they'll see the world from multiple perspectives. All of which are equally interesting and worth pondering. ENTPs generally take on things with more depth and understanding. They love sharing what they know with the people around them.

As intellectuals, ENTPs use their wit not just to solve problems but to understand other people too. They are versatile, open-minded, and restless. ENTPs tend to have a 'wait and see' attitude because they don't want to shut their doors to possibilities. They constantly crave novelty due to their limitless interests.

Rules are just limits; this is a fact for ENTPs. They would gladly challenge the standards, question norms, and even break the rules if they see that it will take them to where they want to be. They are high believers that there is always a better, faster, and more exciting way to deal with things. They like taking risks even if they know it could lead them to failure because, for them, failure is an opportunity for growth rather than disappointment. They love cheating the system and looking for gray areas that they can take advantage of to make the rules work in their favor.", 
    "ESTJ" = "ESTJ stands for Extravert, Sensing, Thinking, and Judging, which means they are practical, organized, and decisive. As one of the 16 personality types in the MBTI framework, ESTJs are natural leaders who excel in managing people and projects with efficiency and structure. This personality type thrives on order and responsibility, making them reliable and results-oriented individuals.

ESTJs are strong leaders who are dedicated, hard-working, honest, and reliable. Their no-nonsense, take-charge demeanor helps the people around them feel secure. You can count on them to be direct, whether telling the hard truth or not playing games when letting you know their interest. They value their friends and family and uphold the traditional values that keep family and society together.

Systematic, organized, and straightforward, ESTJs place great importance on objectivity. They make sure to set their emotions aside when coming up with decisions. For them, emotions are not a priority. ESTJs see emotions as signs of weakness and a hindrance to achieving their goals. They typically deal with essential matters in an impersonal manner. ESTJs have a 'cut to the chase' attitude since they are firm and direct. They dislike wasting time and are frank with their opinions and feedback. Because of their nature, they may come off as intimidating or harsh, but in reality, ESTJs mean well.

ESTJs are moral and honest individuals. They despise cheating, laziness, and disobedience. They typically have strong principles that are hard to waver. ESTJs have a clear set of beliefs and a particular set of standards that they wish to be followed by everyone else.

Uncertainties don't sit well with ESTJs. They thrive well when they know how everything works and when things are going according to how they are planned. ESTJs always want to be updated on what to expect. Making sure that everything is organized is something that ESTJs are obsessed with. When there is chaos, ESTJs usually tap on historical information. They check what methods or systems worked in the past and believe that they will work again in the present. ESTJs are comfortable with existing and established procedures.

ESTJs are people who like taking charge. When ESTJs set a goal for themselves, they are unstoppable until that is achieved. They are willing to conquer the most challenging task to get what they want. They are efficient and capable of making complicated tasks easier. Putting plans into action and turning huge goals into simple steps is what ESTJs are great at. As goal-oriented people, ESTJs dislike when those around them fail to deliver. Frequently they may forget how other people may feel because they care about their demands more.", 
    "ESFJ" = "The ESFJ personality type stands for Extraverted, Sensing, Feeling, and Judging. As one of the 16 personality types in the MBTI framework, ESFJs are outgoing, detail-oriented, empathetic, and organized. They thrive in social settings, prioritize harmony, and are often seen as the caregivers in their communities. ESFJs excel in roles that require nurturing and support, making them invaluable in both personal and professional relationships.

ESFJs are caring, loyal, and attentive to others’ needs, ensuring the people around them are taken care of. Often the social butterflies and center of a community, they empathize easily with others. People are drawn to their social grace, warmth, and no-nonsense practical nature. They do not shy away from commitments and responsibility and find possible solutions to help those struggling.

As organizational enthusiasts, ESFJs like to plan everything, with whom the unknown does not sit well. ESFJs are not big fans of anything that is not solid and reliable, like abstracts, theories, concepts, and impersonal analysis. ESFJs crave a stable life, which is why they always see that everything is alright. ESFJs enjoy taking part in communities and organizations. Delivering more than what is expected from them is something people can always expect from ESFJs.

Like how ESFJs value tradition, community, and morality. ESFJs frequently see no room for uncertainty. Everything is either black or white in their eyes. Their morality is mostly based on what society deems to be proper and wrong. They may be judgmental as a result, but only because of how they see the world and their desire to keep things in order.

ESFJs often have high expectations of other people. They encourage them to pursue their full potential. Often, they refuse to see the bad in people – especially those close to them. They love helping and being selfless, but along with it, ESFJs wish to be seen and appreciated. When they are not noticed for what they do, ESFJs feel unmotivated or rejected. ESFJs are people pleasers and providers. They often have a strong desire to be in control and send as much help to others as possible. As someone obsessed with social status, ESFJs think about how others perceive them.", 
    "ENFJ" = "ENFJ is a personality type characterized by Extraverted, Intuitive, Feeling, and Judging traits, making them natural-born leaders who are empathetic, insightful, and organized. As part of the MBTI's 16 personality types, ENFJs excel in understanding and motivating others, often taking on roles that allow them to guide and support those around them. Their ability to connect on a deep emotional level and their strong sense of responsibility make them ideal for fostering harmonious and productive environments, whether in personal relationships or professional settings.

ENFJs are people with others' wellbeing at the heart of their purpose. They're diplomatic, polite, and skilled at managing relationships. They have a gift for understanding others' feelings and motives and do their best not only to keep the peace in their communities and relationships but to anticipate and support others' needs. Nothing gives them more satisfaction at the end of a day than being appreciated for all the hard work they do for their friends and loved ones.

Warm, outgoing, loyal, and sensitive are some of the words commonly used to describe ENFJs. People with this personality type are renowned for their exceptional capacity to uplift others and effect constructive change in the world. They are emotionally intelligent people who can read what people around them feel. They are willing to do anything for the people they care about. As a result, they are frequently said to be one of the most selfless people.

Principles and ethics are extremely important for ENFJs. They are the people who will fight for what is right no matter what. No one can convince them to do things that are against their morals. They do not tolerate injustice and wrongdoings. Their excellent communication skills come in handy during these times. ENFJs are like this because they genuinely care and want the world to improve. They also use their charisma and natural influence to encourage others to stand up for what is right.

If there is someone who can gather people and encourage them to work together for the common good, they would probably be the ENFJs. ENFJs are good at bringing consensus among diverse people. For this reason, they can be outstanding leaders and bring enthusiasm to a group that can be motivating and inspirational. They are leaders who inspire and help instead of dictating.

ENFJs frequently do best in settings and circumstances where they can help others exhibit their full potential and engage in social interaction. People with ENFJ personalities are great problem solvers, too. They excel at settling disputes and fostering unity. ENFJs make great public servants, leaders, counselors, teachers, and influencers.

ENFJs' capability to bring positive impact to other people is what sets them apart. They are excellent communicators who frequently exhibit warmth, affection, and support. ENFJs excel at motivating people and find delight in doing good deeds. They experience the same happiness when they see those around them achieve in life.", 
    "ENTJ" = "ENTJ stands for Extrovert, Intuitive, Thinking, and Judging, making it one of the 16 personality types in the MBTI framework. Known as the Commander, this personality type is characterized by strong leadership qualities, strategic thinking, and a natural inclination for taking charge. ENTJs are decisive, goal-oriented, and thrive in environments where they can implement their vision and drive results. As a pioneering psychology tech company, Boo helps ENTJs find compatible friends and partners who can match their dynamic and ambitious nature.

ENTJs are masters of efficiency, formidable, confident, and a force to be reckoned with. They like being at the forefront, taking on life's challenges head-on, and moving the world forward. They're intellectual, confident, and visionary, making them extremely attractive, especially to those seeking direction.

Natural-born leaders, ENTJs have an innate passion for guiding others toward ambitious goals. They are comfortable taking charge, sometimes even without knowing it. ENTJs can detect complexities and instantly visualize a path to take to get over those. Their decisiveness is a significant factor in why they are excellent leaders.

ENTJs are organizers of change. There is no place for errors or inefficiencies for ENTJs because for them these will hinder them from changing for the better. ENTJs are assertive and innovative and enjoy planning and setting long-term goals. This way, the future will not be uncertain or out of track. ENTJs thrive when there is predictability and control, that is why they make sure to keep everything structured and organized as early as possible.

Excellent with verbal communication and humor, ENTJs have no trouble making friends. However, they may sometimes neglect other people's feelings and opinions, especially when making decisions. ENTJs would much rather not have to deal with other people's emotions and can often struggle to manage their own. ENTJs are strong characters who prefer to not to show their feelings.

Rationality and incredible problem radar help ENTJs prevail against any challenge. ENTJs see problems before they happen and cause more problems. Being able to see a problem early on will give ENTJs ample time to come up with a solid plan of action. Fantastic logical reasoning and quick thinking allow ENTJs to thrive in all the challenging situations that may come their way."
  )
  
  observeEvent(input$instructions, {
    updateTabsetPanel(session, "mainTabset", selected = "Instructions")
  })
  
  observeEvent(input$take_test, {
    updateTabsetPanel(session, "mainTabset", selected = "Take Test")
  })
  
  observeEvent(input$submitbutton, {
    updateTabsetPanel(session, "mainTabset", selected = "Results")
  })
  
  observeEvent(input$continue, {
    updateTabsetPanel(session, "mainTabset", selected = "Personality DataBase")
  })
  
  personality_descriptions <- list(
    "ISTJ" = "The Inspector: You are a reliable and responsible 
    person who values tradition and order.",
    "ISFJ" = "The Defender: You are a warm, nurturing helper who is 
    deeply loyal and quietly supportive.",
    "INFJ" = "The Advocate: You are an insightful and principled 
    idealist who seeks meaning and harmony in all things.",
    "INTJ" = "The Mastermind: You are a strategic, independent thinker 
    who sees long-term possibilities.",
    "ISTP" = "The Virtuoso: You are a curious and hands-on problem 
    solver who thrives on independence and action.",
    "ISFP" = "The Artist: You are a quiet, creative spirit who values 
    beauty, freedom, and authenticity.",
    "INFP" = "The Mediator: You are a gentle, imaginative soul with a 
    deep sense of empathy and creativity.",
    "INTP" = "The Thinker: You are an analytical problem-solver who 
    thrives on abstract concepts and innovation.",
    "ESTP" = "The Dynamo: You are an energetic thrill-seeker who lives 
    in the moment and loves to take risks.",
    "ESFP" = "The Entertainer: You are a vibrant, fun-loving individual 
    who lights up any room and lives for excitement.",
    "ENFP" = "The Campaigner: You are a lively, free-spirited person who 
    thrives on creativity and human connection.",
    "ENTP" = "The Visionary: You are a charismatic innovator who loves 
    debating ideas and challenging norms.",
    "ESTJ" = "The Executive: You are a practical and efficient organizer 
    who leads with clarity and structure.",
    "ESFJ" = "The Consultant: You are a sociable, caring individual who 
    finds fulfillment in helping others feel welcome.",
    "ENFJ" = "The Protagonist: You are a charismatic leader who inspires 
    others with vision, empathy, and authenticity.",
    "ENTJ" = "The Commander: You are a natural leader who is decisive, 
    efficient, and driven by achievement."
  )
  
  personality_colors <- list(
    "ISTJ" = "#5D8AA8", 
    "ISFJ" = "#89CFF0", 
    "INFJ" = "#6F4E37", 
    "INTJ" = "#702963", 
    "ISTP" = "#B87333", 
    "ISFP" = "#DAA520", 
    "INFP" = "#00A550", 
    "INTP" = "#C3B091", 
    "ESTP" = "#E97451", 
    "ESFP" = "#FFBF00", 
    "ENFP" = "#FF7F50", 
    "ENTP" = "#5218FA", 
    "ESTJ" = "#9F8170", 
    "ESFJ" = "#F88379", 
    "ENFJ" = "#AFE313", 
    "ENTJ" = "#800020"  
  )
  
  personality_images <- list(
    "ISTJ" = "ISTJ.jpg", 
    "ISFJ" = "ISFJ.jpg", 
    "INFJ" = "INFJ.jpg",
    "INTJ" = "INTJ.jpg", 
    "ISTP" = "ISTP.jpg", 
    "ISFP" = "ISFP.jpg", 
    "INFP" = "INFP.jpg", 
    "INTP" = "INTP.jpg", 
    "ESTP" = "ESTP.jpg", 
    "ESFP" = "ESFP.jpg", 
    "ENFP" = "ENFP.jpg", 
    "ENTP" = "ENTP.jpg",
    "ESTJ" = "ESTJ.jpg",
    "ESFJ" = "ESFJ.jpg", 
    "ENFJ" = "ENFJ.jpg", 
    "ENTJ" = "ENTJ.jpg"  
  )
  
  personality_name1 <- list(
    "ISTJ" = "ISTJGW.jpg", 
    "ISFJ" = "ISFJMT.png", 
    "INFJ" = "INFJML.png", 
    "INTJ" = "INTJMO.png", 
    "ISTP" = "ISTPMM.jpg", 
    "ISFP" = "ISFPMJ.jpg", 
    "INFP" = "INFPKC.jpg", 
    "INTP" = "INTPBG.jpg", 
    "ESTP" = "ESTPAJ.jpg", 
    "ESFP" = "ESFPCR.jpg", 
    "ENFP" = "ENFPAF.jpg",# 
    "ENTP" = "ENTPBO.jpg", 
    "ESTJ" = "ESTJGR.jpg", 
    "ESFJ" = "ESFJTS.jpg", 
    "ENFJ" = "ENFJTS.jpg", 
    "ENTJ" = "ENTJSJ.jpg"  
  )
  
  personality_name1_info <- list(
    "ISTJ" = "George Washington", 
    "ISFJ" = "Mother Teresa", 
    "INFJ" = "Martin Luther King", 
    "INTJ" = "Michelle Obama", 
    "ISTP" = "Marshal Mathers 'Eminem'", 
    "ISFP" = "Micheal Jackson", 
    "INFP" = "Kurt Cobain", 
    "INTP" = "Bill Gates", 
    "ESTP" = "Angelina Jolie", 
    "ESFP" = "Christiano Ronaldo", 
    "ENFP" = "Anne Frank",# 
    "ENTP" = "Barack Obama", 
    "ESTJ" = "Gordon Ramsay", 
    "ESFJ" = "Taylo Swift", 
    "ENFJ" = "Tupac Shakur", 
    "ENTJ" = "Steve Jobs"  
  )
  
  personality_name2 <- list(
    "ISTJ" = "ISTJDV_f.jpg", 
    "ISFJ" = "ISFJCA_f.jpg", 
    "INFJ" = "INFJLL_f.jpg", 
    "INTJ" = "INTJGM_f.jpg", 
    "ISTP" = "ISTPSk_f.jpg", 
    "ISFP" = "ISFPJS_f.jpg", 
    "INFP" = "INFPPP_f.jpg", 
    "INTP" = "INTPSH_f.jpg", 
    "ESTP" = "ESTPIH_f.jpg", 
    "ESFP" = "ESFPJT_f.jpg", 
    "ENFP" = "ENFPWW_f.jpg",# 
    "ENTP" = "ENTPJDk_f.jpg", 
    "ESTJ" = "ESTJHG_f.jpg", 
    "ESFJ" = "ESFJSB_f.jpg", 
    "ENFJ" = "ENFJJG_f.jpg", 
    "ENTJ" = "ENTJS_f.jpg"  
  )
  
  personality_name2_info <- list(
    "ISTJ" = "Darth Vader - Star Wars", 
    "ISFJ" = "Steve Rogers 'Captain America' - Marvel", 
    "INFJ" = "Loki Laufeyson - Marvel", 
    "INTJ" = "Gandalf - The Lord of the Rings", 
    "ISTP" = "Shrek", 
    "ISFP" = "John Snow - Game of Thrones", 
    "INFP" = "Peter Parker 'Spiderman' - Marvel", 
    "INTP" = "Sherlock Holmes", 
    "ESTP" = "Inosuke Hashibira - Demon Slayer", 
    "ESFP" = "Joey Tribbiani - F.R.I.E.N.D.S", 
    "ENFP" = "Willy Wonka - Charlie and the Chocolate Factory",# 
    "ENTP" = "The Joker - The Dark Knight", 
    "ESTJ" = "Hermione Granger - Harry Potter", 
    "ESFJ" = "SpongeBob SquarePants", 
    "ENFJ" = "John GIlman 'Homelander' - The Boys", 
    "ENTJ" = "Sauron - The Lord of the Rings"  
  )
  
  
  selected_type <- reactiveVal(NULL)
  
  observeEvent(input$btn_INFJ, { selected_type("INFJ") })
  observeEvent(input$btn_INTJ, { selected_type("INTJ") })
  observeEvent(input$btn_ENFP, { selected_type("ENFP") })
  observeEvent(input$btn_ENTP, { selected_type("ENTP") })
  observeEvent(input$btn_INFP, { selected_type("INFP") })
  observeEvent(input$btn_ISFP, { selected_type("ISFP") })
  observeEvent(input$btn_ENFJ, { selected_type("ENFJ") })
  observeEvent(input$btn_ESFJ, { selected_type("ESFJ") })
  
  observeEvent(input$btn_INTP, { selected_type("INTP") })
  observeEvent(input$btn_ISTP, { selected_type("ISTP") })
  observeEvent(input$btn_ENTJ, { selected_type("ENTJ") })
  observeEvent(input$btn_ESTJ, { selected_type("ESTJ") })
  observeEvent(input$btn_ISFJ, { selected_type("ISFJ") })
  observeEvent(input$btn_ISTJ, { selected_type("ISTJ") })
  observeEvent(input$btn_ESFP, { selected_type("ESFP") })
  observeEvent(input$btn_ESTP, { selected_type("ESTP") })
  
  
  output$personality_info_ui <- renderUI({
    req(as.character(selected_type()))
    
    info <- personality_data[[selected_type()]]
    sections <- unlist(strsplit(info, "\n\n"))
    
    div(
      style = "margin-top: 30px; background-color: #1a1a1a; border-radius: 10px; padding: 30px; border-left: 4px solid #50e3c2;",
      
      h2(selected_type(), style = paste0("color:",personality_colors[[selected_type()]],"; margin-bottom: 25px; font-weight: bold;")),
      
      lapply(sections, function(para) {
        p(para, style = "color: #ffffff; font-size: 18px; margin-bottom: 15px; line-height: 1.6;")
      }),
      
      tags$hr(style = "border-color: #50e3c2; margin: 30px 0;"),
      
      h3("Data Visualization", style = "color: #50e3c2; margin-bottom: 20px;"),
      
      div(
        style = "display: flex; flex-wrap: wrap; gap: 20px; justify-content: space-between;",
        
        div(
          style = "flex: 1; min-width: 45%;",
          h4("Overall Frequency Density of Cognitive Function Scores", 
             style = "color: #ffffff; margin-bottom: 15px; text-align: center;"),
          plotOutput("score_plots", height = "400px")
        ),
        
        div(
          style = "flex: 1; min-width: 45%;",
          h4("Average Cognitive Function Scores", 
             style = "color: #ffffff; margin-bottom: 15px; text-align: center;"),
          plotOutput("radar_plot", height = "400px")
        )
      ),
      p("Data based on personality assessment results",
        style = "color: #999999; font-size: 14px; margin-top: 30px; font-style: italic;")
    )
  })
  
  output$score_plots <- renderPlot({
    req(selected_type(), rw_data)
    
    filtered_data <- rw_data %>%
      filter(Personality == selected_type())
    
    long_data <- filtered_data %>%
      pivot_longer(
        cols = c(Introversion.Score, Sensing.Score, Thinking.Score, Judging.Score),
        names_to = "Trait",
        values_to = "Score"
      )
    
    long_data$Trait <- gsub("\\.Score", "", long_data$Trait)
    
    trait_colors <- c(
      "Introversion" = "#FF6B6B",
      "Sensing" = "#4ECDC4",
      "Thinking" = "#FFD166",
      "Judging" = "#118AB2"
    )
    
    ggplot(long_data, aes(x = Score, color = Trait, fill = Trait)) +
      geom_density(alpha = 0.4, linewidth = 1.2) +
      scale_color_manual(
        values = trait_colors,
        labels = c(
          "Introversion" = "Introversion Vs Extraversion",
          "Sensing" = "Sensing Vs Intuition",
          "Thinking" = "Thinking Vs Feeling",
          "Judging" = "Judging Vs Perceiving"
        )
      ) +
      scale_fill_manual(
        values = trait_colors,
        labels = c(
          "Introversion" = "Introversion Vs Extraversion",
          "Sensing" = "Sensing Vs Intuition",
          "Thinking" = "Thinking Vs Feeling",
          "Judging" = "Judging Vs Perceiving"
        )
      ) +
      labs(x = "Score", y = "Density") +
      theme_minimal(base_size = 14) +
      theme(
        plot.background = element_rect(fill = "#1a1a1a", color = NA),
        panel.background = element_rect(fill = "#1a1a1a", color = NA),
        panel.grid.major = element_line(color = "#1a1a1a", linewidth = 0.5),
        panel.grid.minor = element_blank(),
        text = element_text(color = "white", face = "bold"),
        axis.text = element_text(color = "#cccccc", size = 14, face = "bold"),
        axis.title = element_text(color = "white", size = 16, face = "bold"),
        legend.title = element_blank(),
        legend.background = element_rect(fill = "#1a1a1a"),
        legend.text = element_text(color = "white", size = 14, face = "bold"),
        legend.key = element_rect(fill = NA),
        legend.position = "bottom"
      )
  })
  
  
  output$radar_plot <- renderPlot({
    req(selected_type(), rw_data)
    
    type_letters <- strsplit(selected_type(), "")[[1]]
    
    filtered_data <- rw_data %>%
      filter(Personality == selected_type())
    
    avg_scores <- tibble(
      Introversion = if ("I" %in% type_letters) 10 - mean(filtered_data$Introversion.Score) else 0,
      Sensing = if ("S" %in% type_letters) mean(filtered_data$Sensing.Score) else 0,
      Thinking = if ("T" %in% type_letters) mean(filtered_data$Thinking.Score) else 0,
      Judging = if ("J" %in% type_letters) mean(filtered_data$Judging.Score) else 0,
      
      Extraversion = if ("E" %in% type_letters) mean(filtered_data$Introversion.Score) else 0,
      Intuition = if ("N" %in% type_letters) 10 - mean(filtered_data$Sensing.Score) else 0,
      Feeling = if ("F" %in% type_letters) 10 - mean(filtered_data$Thinking.Score) else 0,
      Perceiving = if ("P" %in% type_letters) 10 - mean(filtered_data$Judging.Score) else 0
    )
    
    trait_names <- c("Introversion", "Sensing", "Thinking", "Judging",
                     "Extraversion", "Intuition", "Feeling", "Perceiving")
    
    radar_data <- data.frame(matrix(ncol = length(trait_names), nrow = 0))
    colnames(radar_data) <- trait_names
    
    radar_data <- rbind(rep(10,8),rep(0,8),avg_scores,radar_data)
    par(family = "sans", fg = "white", mar = c(1, 1, 1, 1))
    
    radarchart(
      radar_data,
      axistype = 1,                                 # Axis with value labels
      caxislabels = c("0", "2.5", "5", "7.5", "10"),# Custom axis labels
      pcol = adjustcolor("#50e3c2", alpha.f = 0.4), # Line color
      pfcol = adjustcolor("#118AB2", alpha.f = 0.4),# Fill with transparency
      plwd = 4,                                     # Line width
      plty = 1,                                     # Line type: solid
      cglcol = "#2F4858",                           # Grid lines color (lighter for contrast)
      cglty = 1,                                     # Solid grid lines
      cglwd = 1.2,                                  # Thicker grid lines for prominence
      axislabcol = "#F4A261",                         # Axis label numbers in white
      vlcex = 1.5,                                   # Font size for trait labels
      vlabels = trait_names,                        # Trait names
      title = NULL                                  # No title
    )
    
  }, bg = "#1a1a1a")
  
  
  observeEvent(input$submitbutton, {
    req(input$Age, input$Gender, input$Education, input$Interest,
        input$ei1, input$ei2, input$ei3, input$ei4, input$ei5, input$ei6, input$ei7,
        input$ns1, input$ns2, input$ns3, input$ns4, input$ns5, input$ns6, input$ns7,
        input$ft1, input$ft2, input$ft3, input$ft4, input$ft5, input$ft6, input$ft7,
        input$pj1, input$pj2, input$pj3, input$pj4, input$pj5, input$pj6, input$pj7)
    
    test <- data.frame(
      Age = log(as.numeric(input$Age)),
      Gender = factor(input$Gender, levels = c("Female", "Male")),
      Education = factor(input$Education, levels = c("0", "1")),
      Introversion.Score = (as.numeric(input$ei1) + as.numeric(input$ei2) + as.numeric(input$ei3) + as.numeric(input$ei4) + as.numeric(input$ei5) + as.numeric(input$ei6) + as.numeric(input$ei7))/7,
      Sensing.Score = (as.numeric(input$ns1) + as.numeric(input$ns2) + as.numeric(input$ns3) + as.numeric(input$ns4) + as.numeric(input$ns5) + as.numeric(input$ns6) + as.numeric(input$ns7))/7,
      Thinking.Score = (as.numeric(input$ft1) + as.numeric(input$ft2) + as.numeric(input$ft3) + as.numeric(input$ft4) + as.numeric(input$ft5) + as.numeric(input$ft6) + as.numeric(input$ft7))/7,
      Judging.Score = (as.numeric(input$pj1) + as.numeric(input$pj2) + as.numeric(input$pj3) + as.numeric(input$pj4) + as.numeric(input$pj5) + as.numeric(input$pj6) + as.numeric(input$pj7))/7,
      Interest = factor(input$Interest, levels = c("Arts", "Others", "Sports", "Technology", "Unknown"))
    )
    
    prediction <- predict(model, test, type = "class")
    
    output$results_panel <- renderUI({
      personality_type <- as.character(prediction)
      bg_color <- personality_colors[[personality_type]]
      
      div(
        div(
          style = "padding: 20px;",
          
          div(
            style = "display: flex; justify-content: space-between; align-items: 
            center; margin-bottom: 40px;",
            div(
              h2("YOU ARE AN ", style = "font-size: 2.5rem; font-weight: bold; 
                 margin-bottom: 2.5rem; color: #50e3c2"),
              h1(personality_type, style = paste0("font-size: 56px; font-weight: 
              bold; color: ", bg_color, "; 
                                                  font-size: 2.5rem; font-weight:
                                                  bold; margin-bottom: 0.5rem;")),
              p(personality_descriptions[[personality_type]], 
                style = paste0("font-size: 32px;font-style: italic; color: ", bg_color, ";")),
              
            ),
            
            div(
              style = "flex: 1; text-align: right; min-width: 250px;",
              tags$img(
                src = personality_images[[personality_type]],
                width = "400px",
                height = "400px",
                class = "personality-image",
                alt = paste("Image representing", personality_type, "personality type"),
                style = paste0("border: 5px solid ", bg_color, "; border-radius: 15px;")
              )
            )
          )
        ),
        
        br(),
        
        div(
          style = "padding: 20px;",
          
          div(
            style = "justify-content: space-between; align-items: center; margin-bottom: 40px;",
            div(
              h2("Your Results Explained", style = "color : #50e3c2;"),
              p("Based on your answers to the questionnaire and your demographic information, the model
              predicts that your personality type is ",  
                strong(span(personality_type, style = paste0("color: ", bg_color, ";"))), 
                ".", style = "font-size: 24px; color: white;"),
              p("This type is characterized by the following traits:", style = "font-size: 24px; color: white;"),
              
              div(class = "trait-box", style = paste0("background: linear-gradient(135deg, ", bg_color, "30, ", bg_color, "10);
                                        border-radius: 10px; padding: 15px; margin: 10px 0; width: 100%; display: block;"),
                  h3(paste0(ifelse(substr(personality_type, 1, 1) == "E", "Extraversion (E)", "Introversion (I)")),
                     style = "font-size: 2.2rem; font-weight: bold; margin-bottom: 0.5rem; color: #50e3c2"),
                  p(ifelse(substr(personality_type, 1, 1) == "E", 
                           "You gain energy from social interactions and the external world.",
                           "You gain energy from time alone and your internal world."),style = "font-size: 24px;")
              ),
              
              div(class = "trait-box",style = paste0("background: linear-gradient(135deg, ", bg_color, "30, ", bg_color, "10);
                                                    border-radius: 10px; padding: 15px; margin: 10px 0;"),
                  h3(paste0(ifelse(substr(personality_type, 2, 2) == "S", "Sensing (S)", "Intuition (N)")),
                     style = "font-size: 2.2rem; font-weight: bold; margin-bottom: 0.5rem; color: #50e3c2"),
                  p(ifelse(substr(personality_type, 2, 2) == "S", 
                           "You focus on concrete facts and details.",
                           "You focus on patterns, possibilities, and the big picture."),style = "font-size: 24px;")
              ),
              
              div(class = "trait-box", style = paste0("background: linear-gradient(135deg, ", bg_color, "30, ", bg_color, "10);
                                                    border-radius: 10px; padding: 15px; margin: 10px 0;"),
                  h3(paste0(ifelse(substr(personality_type, 3, 3) == "T", "Thinking (T)", "Feeling (F)")),
                     style = "font-size: 2.2rem; font-weight: bold; margin-bottom: 0.5rem; color: #50e3c2"),
                  p(ifelse(substr(personality_type, 3, 3) == "T", 
                           "You make decisions based on logic and objective analysis.",
                           "You make decisions based on values and considering people's feelings."),style = "font-size: 24px;")
              ),
              
              div(class = "trait-box", style = paste0("background: linear-gradient(135deg, ", bg_color, "30, ", bg_color, "10);
                                                    border-radius: 10px; padding: 15px; margin: 10px 0;"),
                  h3(paste0(ifelse(substr(personality_type, 4, 4) == "J", "Judging (J)", "Perceiving (P)")),
                     style = "font-size: 2.2rem; font-weight: bold; margin-bottom: 0.5rem; color: #50e3c2"),
                  p(ifelse(substr(personality_type, 4, 4) == "J", 
                           "You prefer structure, planning, and organization.",
                           "You prefer flexibility, spontaneity, and keeping options open."),style = "font-size: 24px;")
              )
            )
          )
        ),
        
        br(),
        div(
          style = "padding: 20px; margin-bottom: 40px;",
          div(
            style = "display: flex; justify-content: space-between; align-items: flex-start; width: 100%;",
            
            div(
              class = "profile-table-container",
              style = "flex: 1; font-size: 24px;", 
              h2("Profile Information", style = "color : #50e3c2;"),
              tableOutput("profile_data")
            ),
            
            div(
              style = "margin-left: 40px; display: flex; align-items: center; justify-content: center;",
              actionButton("continue", "CONTINUE", 
                           style = "background-color: #50e3c2; color: #000000; border: none; border-radius: 50px; padding: 20px 50px; font-size: 20px; font-weight: bold; min-width: 200px;")
            )
          )
        )
      )
    })
    
    personality_jobs <- list(
      "ISTJ" = "ISTJjobs.png", 
      "ISFJ" = "ISFJjobs.png", 
      "INFJ" = "INFJjobs.png", 
      "INTJ" = "INTJjobs.png", 
      "ISTP" = "ISTPjobs.png", 
      "ISFP" = "ISFPjobs.png", 
      "INFP" = "INFPjobs.png", 
      "INTP" = "INTPjobs.png", 
      "ESTP" = "ESTPjobs.png", 
      "ESFP" = "ESFPjobs.png", 
      "ENFP" = "ENFPjobs.png",# 
      "ENTP" = "ENTPjobs.png", 
      "ESTJ" = "ESTJjobs.png", 
      "ESFJ" = "ESFJjobs.png", 
      "ENFJ" = "ENFJjobs.png", 
      "ENTJ" = "ENTJjobs.png"  
    )
    
    output$results_panel1 <- renderUI({
      personality_type <- as.character(prediction)
      bg_color <- personality_colors[[personality_type]]
      
      div(
        div(
          style = "padding: 20px;",
          
          div(
            style = "justify-content: space-between; align-items: center; margin-bottom: 20px;",
            div(
              h2("YOUR PERSONALITY IS SHARED WITH ", style = "color : #50e3c2; margin-bottom: 2.5rem;"),
              
              div(class = "trait-box", style = paste0("background: linear-gradient(135deg, ", bg_color, "30, ", bg_color, "10);
                                        border-radius: 10px; width: 100%; display: block;"),
                  div(
                    style = "padding: 20px;",
                    
                    div(
                      style = "display: flex; justify-content: space-between; align-items: center; margin-bottom: 18px;",
                      div(
                        h3(personality_name1_info[[personality_type]], style = "font-weight: bold; margin-bottom: 0 rem; color: #50e3c2"),
                        
                      ),
                      
                      div(
                        style = "flex: 1; display: flex; align-items: center; justify-content: flex-end; min-width: 250px;",
                        tags$img(
                          src = personality_name1[[personality_type]],
                          width = "180px",
                          height = "180px",
                          class = "personality-image",
                          alt = paste("Image representing", personality_type, "personality type"),
                          style = paste0("border: 5px solid ", bg_color, "; border-radius: 15px;")
                        )
                      )
                    )
                  )
              ),
              
              div(class = "trait-box", style = paste0("background: linear-gradient(135deg, ", bg_color, "30, ", bg_color, "10);
                                        border-radius: 10px; width: 100%; display: block;"),
                  div(
                    style = "padding: 20px;",
                    
                    div(
                      style = "display: flex; justify-content: space-between; align-items: center; margin-bottom: 18px;",
                      div(
                        h3(personality_name2_info[[personality_type]], style = "font-weight: bold; margin-bottom: 0 rem; color: #50e3c2"),
                        
                      ),
                      
                      div(
                        style = "flex: 1; display: flex; align-items: center; justify-content: flex-end; min-width: 250px;",
                        tags$img(
                          src = personality_name2[[personality_type]],
                          width = "180px",
                          height = "180px",
                          class = "personality-image",
                          alt = paste("Image representing", personality_type, "personality type"),
                          style = paste0("border: 5px solid ", bg_color, "; border-radius: 15px;")
                        )
                      )
                    )
                  )
              )
            )
          )
        ),
        
        br(),
        
        div(
          style = "padding: 20px;",
          
          div(
            style = "align-items: center; margin-bottom: 40px;",
            div(
              style = "text-align: center;", 
              h2("PROSPECTIVE CAREER OPTIONS FOR YOU TO CONSIDER: ", style = "color: #50e3c2; margin-bottom: 0rem;"),
              
              div(class = "trait-box", style = paste0("border-radius: 10px; padding: 15px; margin: 10px 0; width: 100%; display: block;"),
                  div(
                    style = "padding: 20px;",
                    
                    div(
                      style = "display: flex; justify-content: center; align-items: center; margin-bottom: 18px;", 
                      
                      div(
                        style = "display: flex; align-items: center; justify-content: center;", 
                        tags$img(
                          src = personality_jobs[[personality_type]],
                          width = "550px",
                          height = "350px",
                          class = "personality-image",
                          alt = paste("Image representing", personality_type, "personality type"),
                          style = paste0("border: 5px solid ", bg_color, "; border-radius: 15px;")
                        )
                      )
                    )
                  )
              )
            )
          )
        )
      )
    })
    
    output$profile_data <- renderTable({
      data.frame(
        "Parameter" = c("Age", "Gender", "Education", "Field of Interest", 
                        "E/I Score", "S/N Score", "T/F Score", "J/P Score"),
        "Value" = c(
          input$Age,
          input$Gender,
          ifelse(input$Education == "0", "Below Post Graduate Level", "Post Graduate Level or Above"),
          input$Interest,
          round((input$ei1 + input$ei2 + input$ei3 + input$ei4 + input$ei5 + input$ei6 + input$ei7)/7,3),
          round((input$ns1 + input$ns2 + input$ns3 + input$ns4 + input$ns5 + input$ns6 + input$ns7)/7,3),
          round((input$ft1 + input$ft2 + input$ft3 + input$ft4 + input$ft5 + input$ft6 + input$ft7)/7,3),
          round((input$pj1 + input$pj2 + input$pj3 + input$pj4 + input$pj5 + input$pj6 + input$pj7)/7,3)
        )
      )
    })
  })
}

shinyApp(ui = ui, server = server)