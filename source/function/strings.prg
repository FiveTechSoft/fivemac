// FWH strings multiple languages support

#include "Fivemac.ch"

static nLanguage := 0   // Initially will be set by LanguageID() function
// 1 English, 2 Spanish, 3 French, 4 Portugese, 5 German, 6 Italian

static aStrings := { ;
{ "Attention", "Atenci�n", "Attention", "Aten��o", "Achtung", "Attenzione" }, ;
{ "PDF Plugin Error", "Error del plugin de PDF", "Erreur de plugin du PDF", "Erro do plugin do PDF", ;
"PDF Plugin-Fehler", "Errore del plugin PDF" }, ;
{ "PDF not saved to send Email", "No se ha guardado el PDF a enviar por Email", ;
"PDF Non enregistr� pour envoi Email", "PDF n�o foi salvo para mandar por email", ;
"PDF nicht gespeichert um E-Mail zu senden", "PDF non salvato per inviare e-mail" }, ;
{ "MS Word not installed", "MS Word no est� instalado", "MS Word non install�", "MS Word n�o est� instalado", ;
"MS Word ist nicht installiert", "MS Word non � installato" }, ;
{ "Failed to Create Word Document", "No se ha podido crear el documento de Word", ;
"Echec � la cr�ation du document Word", "N�o foi poss�vel criar o documento do Word", ;
"Fehler beim Erstellen des Word-Dokuments", "Impossibile creare il documento di Word" }, ;
{ "There is no output for export", "No hay nada que exportar", "Rien � exporter", "Nada para exportar", ;
"Nichts zu exportiren", "Non vi � alcuna uscita per l'esportazione" }, ;
{ "No .Doc file manipulation software installed", "No hay instalado software para usar ficheros .Doc", ;
"Pas de programme install� pour manipuler les fichiers .Doc", "N�o h� software instalado para usar arquivos .Doc", ;
"Keine .doc Bearbeitungssoftware installiert", ;
"Nessun installato. Software di manipolazione di file Doc" }, ;
{ "not found, imposible to continue", "no se ha encontrado, no se puede continuar", ;
"Pas trouv�, impossible de continuer", "n�o encontrado, imposs�vel continuar", "nicht gefunden! Kann nicht fortsetzen", ;
"Non trovata. Impossible continuare" }, ;
{ "Printing Error", "Error de impresi�n", "Erreur impressi�n", "Erro de impress�o", "Fehler beim Drucken", "Errore di stampa" }, ;
{ "View", "Visualizar", "Visualiser", "Visualizar", "Sehen Sie", "Visualizza" }, ;
{ "Excel not installed", "Excel no est� instalado", "Excel non install�", "Excel n�o est� instalado", ;
"Excel nicht installiert", "Excel non installato" }, ;
{ "Report width is greater than page width", "El ancho del informe es mayor que el ancho de la p�gina", ;
"Largeur du Rapport sup�rieure � la largeur de la page", "A largura do rel�torio � maior que a p�gina", ;
"Breite des Reports ist gr��er als die Seitenbreite", "La larghezza del report � maggiore della larghezza pagina" }, ;
{ "Export to Excel is available only", "Solo est� disponible exportar a Excel", ;
"Export vers Excel uniquement disponible", "Somente a exporta��o para o Excel est� dispon�vel", ;
"Nur Excel-Export ist verf�gbar", "Esporta in Excel � disponibile solo" }, ;
{ "for Reports with ::bInit defined", "para reportes con ::bInit definido", "pour Rapports avec ::bInit d�fini", ;
"para relat�rios com ::bInit definido", "F�r Berichte, die mit :: bInit definiert sind", ;
"Per i Rapporti con definito ::bInit" }, ;
{ "Printing Preview", "Previsualizaci�n de Impresi�n", "visualisation de l'impression", ;
"Previsualiza��o da impress�o", "Druckvorschau", "Anteprima di stampa" }, ;
{ "&File", "&Fichero", "&Fichier", "Ar&quivo", "D&atei", "File" }, ;
{ "&Print", "&Imprimir", "&Imprimer", "&Imprimir", "&Druck", "Stampa" }, ;
{ "Print actual page", "Imprimir la p�gina actual", "Imprimer la Page en Cours", "Imprimir a p�gina atual", ;
"Aktuelle Seite drucken", "Stampa pagina attuale" }, ;
{ "&Exit", "&Salir", "&Quitter", "&Sair", "Exit", "&Uscita" }, ;
{ "Exit from preview", "Salir de la previsualizaci�n", "Quitter la Visualisation", "Sair da previsualiza��o", ;
"Verlassen der Vorschau", "Esci da anteprima" }, ;
{ "Page", "P�gina", "Page", "P�gina", "Seite", "Pagina" }, ;
{ "&First", "&Primera", "&Premi�re", "&Primeira", "Erste", "Prima" }, ;
{ "Go to first page", "Ir a la primera p�gina", "Aller � la premi�re page", "Ir para primeira p�gina", ;
"Zur ersten Seite", "Vai alla prima pagina" }, ;
{ "&Previous", "&Anterior", "&Pr�c�dente", "&Anterior", "Vorherige", "Precedente" }, ;
{ "Go to previous page", "Ir a la p�gina anterior", "Aller � la page pr�c�dente", "Ir para p�gina anterior", ;
"Zur vorherigen Seite", "Vai alla pagina precedente" }, ;
{ "&Next", "&Siguiente", "&Suivante", "Pr�&xima", "N�chste", "Successiva" }, ;
{ "Go to next page", "Ir a la siguiente p�gina", "Aller � la page suivante", "Ir para a pr�xima p�gina", ;
"Gehe zur n�chsten Seite", "Vai alla pagina successiva" }, ;
{ "&Last", "&Ultima", "&Derni�re", "�&ltima", "Letzte", "Ultimo" }, ;
{ "Go to last page", "Ir a la �ltima p�gina", "Aller � la derni�re page", "Zur letzten Seite", ;
"Vai all'ultima pagina", "" }, ;
{ "&Zoom", "&Zoom", "&Zoom", "&Zoom", "&Zoom", "Zoom" }, ;
{ "Page zoom", "P�gina ampliada con zoom", "zoom de la page", "zoom da p�gina", "&Seite zoomen", "Zoom della pagina" }, ;
{ "&Normal", "&Normal", "&Normal", "&Normal", "&Normal", "Normale" }, ;
{ "Page unzoom", "P�gina normal", "Page normale", "P�gina normal", "Seite ungezoomt", "Pagina eliminare lo zoom" }, ;
{ "&Factor", "&Factor", "&Facteur", "&Fator", "Factor", "Fattore" }, ;
{ "Zoom factor", "Factor de zoom", "Facteur de Zoom", "Fator de zoom", "Zoom-Faktor", "Fattore di zoom" }, ;
{ "Factor", "Factor", "Facteur", "Fator", "Faktor", "Fattore" }, ;
{ "&Two pages", "&Dos p�ginas", "&Deux pages", "&Duas p�ginas", "Zwei Seiten", "Due pagine" }, ;
{ "Preview on two pages", "Previsualizaci�n en dos p�ginas", "Visualiser sur deux pages", ;
"Previsualiza��o em duas p�ginas", "Vorschau auf zwei Seiten", "Anteprima su due pagine" }, ;
{ "One &page", "Una &p�gina", "une &page", "Uma p�&gina", "Eine Seite", "Una pagina" }, ;
{ "Preview on one page", "Previsualizaci�n en una p�gina", "Visualiser sur une page", ;
"Previsualiza��o em uma p�gina", "Vorschau auf einer Seite", "Anteprima di una pagina" }, ;
{ "Page number:", "N�mero de p�gina:", "Num�ro de la Page:", "N�mero de p�gina:", "Seitenzahl:", "Numero di pagina:" }, ;
{ "Go to first page", "Ir a la primera p�gina", "Aller � la premi�re page", "Ir para a primeira p�gina", "Zur ersten Seite", "Vai alla prima pagina" }, ;
{ "First", "Primera", "Premi�re", "Primeira", "Erste", "Prima" }, ;
{ "&Page", "&P�gina", "&Page", "P�&gina", "Seite", "Pagina" }, ;
{ "Preview on one page", "Previsualizaci�n en una p�gina", "Visualiser sur une page", "Previsualiza��o em uma p�gina", "Vorschau auf einer Seite", "Anteprima di una pagina" }, ;
{ "Previous", "Anterior", "Pr�c�dente", "Anterior", "Zur�ck", "Precedente" }, ;
{ "Next", "Siguiente", "Suivante", "Pr�xima", "Weiter", "Successiva" }, ;
{ "Last", "Ultima", "Derni�re", "�ltima", "Letzte", "Ultimo" }, ;
{ "Zoom", "Aumentar", "Zoom", "Aumentar", "Zoom", "Zoom" }, ;
{ "Two pages", "Dos p�ginas", "Deux pages", "Duas p�ginas", "Zwei Seiten", "Due pagine" }, ;
{ "Print", "Imprimir", "Imprimer", "Imprimir", "Druck", "Stampa" }, ;
{ "Save to DOC/PDF", "Guardar como DOC/PDF", "Enregistrer Format DOC/PDF", "Salvar como DOC/PDF", ;
"Speichern als DOC/PDF", "Salva per DOC / PDF" }, ;
{ "DOC Format", "Formato DOC", "Format DOC", "Formato DOC", "DOC-Format", "DOC Formato" }, ;
{ "PDF Format", "Formato PDF", "Format PDF", "Formato PDF", "PDF-Format", "Formato PDF" }, ;
{ "Export to PDF", "Exportar a PDF", "Exporter en PDF", "Exportar para PDF", "Export nach PDF", ;
"Esportazione in formato PDF" }, ;
{ "Send by email as PDF", "Enviar por email como PDF", "Evnoi par email format PDF", "Enviar PDF por email", ;
"PDF Senden per E-Mail", "Invia per e-mail in formato PDF" }, ;
{ "Export to MS Word", "Exportar a MS Word", "Exporter vers MS Word", "Exportar para MS Word", ;
"Export nach MS Word", "Esporta in MS Word" }, ;
{ "Export to Excel", "Exportar a Excel", "Exporter vers Excel", "Exportar para Excel", "Export nach Excel", ;
"Esporta in Excel" }, ;
{ "Exit", "Salir", "Quitter", "Sair", "Ende", "Exit" }, ;
{ "Preview", "Previsualizaci�n", "Visualisation", "Previsualiza��o", "Vorschau", "Anteprima" }, ;
{ "Save as", "Guardar como", "Enregistrer Sous", "Salvar como", "Speichern unter", "Salva con nome" }, ;
{ "Printing", "Imprimiendo", "Impression", "Imprimindo", "Drucke", "Stampa" }, ;
{ "Printing page", "Imprimiendo p�gina", "Impression", "Imprimindo", "Druck von Seite", "Stampa" }, ;
{ "&Ok", "&Aceptar", "&OK", "C&onfirmar", "&Ok", "Ok" }, ;
{ "&Cancel", "&Cancelar", "&Annuler", "&Cancelar", "Abbrechen", "Annulla" }, ;
{ "Printing range", "Rango de impresi�n", "Port�e Impression", "Intervalo de impress�o", "Druckseitenbereich", ;
"Intervallo di stampa" }, ;
{ "All", "Todo", "Toutes", "Todo", "Alle", "Tutto" }, ;
{ "Current page", "P�gina actual", "Page en cours", "P�gina atual", "Aktuelle Seite", "La pagina attuale" }, ;
{ "Pages", "P�ginas", "Pages", "P�ginas", "Seiten", "Pagine" }, ;
{ "From", "Desde", "De", "De", "Von", "Da" }, ;
{ "To", "Hasta", "A", "At�", "Bis", "A" }, ;
{ "Undo", "Deshacer", "Annuler", "desfazer", "R�ckg�ngig", "Undo" }, ;
{ "Redo", "Rehacer", "R�tablir", "Refazer", "Redo", "Redo" }, ;
{ "Cut", "Cortar", "couper", "Corte", "Schneiden", "Tagliare" }, ;
{ "Copy", "Copiar", "Copier", "c�pia", "Kopieren", "Copia" }, ;
{ "Copy to clipboard", "Copiar al portapapeles", "Copier", "c�pia", "Kopieren", "Copia" }, ;
{ "Copy to clipboard", "Copiar al portapapeles", "Copier dans le Presse-papiers", "Copiar para �rea de tranfer�ncia", "In die Zwischenablage kopieren", "Copia negli appunti" }, ;
{ "Paste", "Pegar", "coller", "colar", "Einf�gen", "Incolla" }, ;
{ "Delete", "Eliminar", "Supprimer", "Excluir", "L�schen", "Elimina" }, ;
{ "Font", "Fuente", "Police", "Font", "Schriftart", "Carattere" }, ;
{ "Print", "Imprimir", "Imprimer", "Imprimir", "Druck", "Stampa" }, ;
{ "Select All", "Seleccionar Todo", "S�lectionner Tout", "Selecionar tudo", "Alle Ausw�hlen", "Seleziona Tutto" }, ;
{ "Align", "Alinear", "Aligner", "Alinhar", "Ausrichten", "Allinea" }, ;
{ "Left", "Izquierda", "Gauche", "� esquerda", "Links", "Sinistra" }, ;
{ "New", "Nuevo", "Nouveau", "Novo", "Neu", "Nuovo" }, ;
{ "ADO open", "ADO abrir", "ADO ouvrir", "ADO abrir", "ADO �ffnen", "Apri ADO" }, ;
{ "Open", "Abrir", "ouvrir", "Abrir", "�ffnen", "Aprire" }, ;
{ "Center", "Centro", "Centrer", "center", "Mitte", "Centro" }, ;
{ "Right", "Derecha", "Droite", "certo", "Rechts", "Giusto" }, ;
{ "Justify", "Justificar", "Justifier", "justificar", "Ausrichten", "Giustifica" }, ;
{ "Attention", "�Atenci�n", "Attention", "Aten��o", "Achtung", "Attenzione" }, ;
{ "Information", "Informaci�n", "Informations", "Informa��es", "Information","Informazioni" }, ;
{ "Wrong predefined cursor type!", "Wrong tipo de cursor predefinido!", "Mauvais cat�gorie de curseur pr�d�fini!" , ;
"Tipo cursor predefinido errado!", "Falscher vordefinierter Cursor-Typ!", "Tipo di cursore predefinito errato!" }, ;
{ "Want to end ?", "� Desea terminar ?", "Veulent mettre fin ? ", "Quer terminar ?", "M�chten Sie Beenden ?", "Vuoi terminare ?" },;
{ "Recent files", "Ficheros recientes", "Fichiers recents", "Arquivos recentes","Zuletzt verwendet","File recenti" },;
{ "Open this file", "Abrir este fichero", "Ouvrir ce fichier", "Abrir este arquivo","Datei �ffnen","Apri questo file" },;
{ "Recent ADO connections", "Conexiones ADO recientes", "Connections ADO recentes", "Conec��es ADO recentes","Zuletzt verwendete ADO-Verbindungen", "Connessioni ADO recenti" },;
{ "Recent ADO connections strings", "Cadenas de conexi�n ADO recientes", "Cha�nes de connections ADO recentes", "Cadeias de conec��es ADO recentes", "Zuletzt verwendete ADO-Verbindungsdaten", "Recenti stringhe di connessione ADO" },;
{ "Connect to this ADO database", "Conectar a esta base de datos ADO", "Connecter � cette base de donn�es ADO", "Conectar a esta base de dados ADO", "Verbinde zu dieser ADO-Datenbank", "Connettiti con questo database ADO" },;
{ "Preferences", "Preferencias", "Pr�f�rences", "Prefer�ncias", "Pr�ferenzen", "Preferenze" },;
{ "Natural order", "Orden natural", "Ordre natural", "Ordem natural","Keine Sortierung","Ordinamento naturale" },;
{ "Add", "A�adir", "Ajouter", "Adicionar","Hinzuf�gen","Aggiungi" },;
{ "Edit", "Editar", "Editer", "Editar","Bearbeiten","Modifica" },;
{ "Del", "Borrar", "Supprimer", "Excluir" ,"L�schen","Elimina"},;
{ "Top", "Inicio", "D�but", "In�cio" ,"Anfang","Inizio"},;
{ "Bottom", "Final", "Fin", "Final","Ende","Fine" },;
{ "Search", "Buscar", "Chercher", "Procurar","Suchen","Ricerca" },;
{ "Index", "Orden", "Ordre", "Ordem" ,"Ordnung","Indice"},;
{ "Filter", "Filtro", "Filtre", "Filtro","Filter","Filtro" },;
{ "Relations", "Relaciones", "Relations", "Rela��es","Relation","Relazioni" },;
{ "Process", "Proceso", "Processus", "Processo","Prozess","Processi" },;
{ "Struct", "Estructura", "Structure", "Estrutura","Struktur","Struttura" },;
{ "Imp/Exp", "Imp/Exp", "Imp/Exp", "Imp/Exp","Import/Export","Importa/Esporta" },;
{ "Report", "Reporte", "Rapport", "Relat�rio","Report","Stampa" },;
{ "FileName", "Nombre del fichero", "Nom du fichier", "Nome do arquivo","Dateiname","Nome file" },;
{ "NON DELETED", "NO BORRADO", "NON SUPPRIM�", "N�O EXCLUIDO","NICHT GEL�SCHT","NON CANCELLATO" },;
{ "nondeleted", "No borrado", "Non supprim�", "N�o excluido","nicht gel�scht","Non cancellato" },;
{ "Ordered by", "Ordenado por", "Class� par", "Classificado por" ,"Sortiert nach","Ordinato per"},;
{ "Natural order", "Orden natural", "Ordre naturel", "Ordem natural","Unsortiert","Ordinamento naturale" },;
{ "Edit", "Editar", "Editer", "Editar","Bearbeiten","Modifica" },;
{ "Save", "Guardar", "Enregistrer", "Salvar","Speichern","Salva" },;
{ "Prev", "Anterior", "Anterieur", "Anterior","Vorher","Precedente" },;
{ "Value", "Valor", "Valeur", "Valor","Wert","Valore" },;
{ "Please select", "Por favor seleccione", "Choisissez", "Selecione","W�hlen","Seleziona" },;
{ "Please select a DBF", "Por favor seleccione una DBF", "Choisissez un DBF", "Selecione um DBF","W�hlen einer DBF","Seleziona un DBF" },;
{ "(Y/N)", "(S/N)", "(O/N)", "(S/N)","(J/N)","(S/N)" },;
{ "Index builder", "Constructor de �ndices", "Constructeur d�indexes", "Construtor de �ndices","Index erstellen","Costruzione indici" },;
{ "Expression", "Expresi�n", "Expression", "Express�o","Ausdruck","Espressione" },;
{ "Tag", "Tag", "Tag", "Tag","Tag","Tag" },;
{ "For", "Para", "Pour", "Para","Wenn","Per" },;
{ "While", "Mientras", "Pendant", "Enquanto","W�hrend","Mentre" },;
{ "Unique", "Unico", "Unique", "�nico","Eindeutig","Unico" },;
{ "Descending", "Descendente", "Descendant", "Descendente","Absteigend","Discendente" },;
{ "Memory", "Memoria", "M�moire", "Mem�ria","Speicher","Memoria" },;
{ "Scope", "Ambito", "�tendue", "Escopo","Sichtbar","Ambito" },;
{ "Record", "Registro", "Enregistrement", "Registro","Datensatz","Record" },;
{ "Rest", "Restantes", "Restant", "Resto","Restliche","Resto" },;
{ "Progress", "Progreso", "Progr�s", "Progresso","Fortschritt","Progresso" },;
{ "Create", "Crear", "Cr�er", "Criar", "Erzeugen", "Creazione" },;
{ "fields", "campos", "champ", "campo","Felder","campi" },;
{ "Name", "Nombre", "Nom", "Nome","Name","Nome" },;
{ "Type", "Tipo", "Type", "Tipo","Typ","Tipo" },;
{ "Len", "Lon", "Lon", "Com","L�nge","Lunghezza" },;
{ "Dec", "Dec", "Dec", "Dec","Dezimal","Decimali" },;
{ "Code", "C�digo", "Code", "C�digo","Code","Codice" },;
{ "Indexes of ", "Indices de ", "Index de ", "�ndices de","Sortierungen von","Indici di" },;
{ "Order", "Orden", "Ordre", "Ordem","Sortierung","Ordine" },;
{ "TagName", "NombreTag", "NomTag", "NomeTag","TagName","Nometag" },;
{ "BagName", "NombreBag", "NomBag", "NomeBag","BagName","Nomebag" },;
{ "BagExt", "ExtBag", "ExtBag", "ExtBag","ExtBag","Bagext" },;
{ "Incremental", "Incremental", "Incr�mental", "Incremental","Inkrementell","Incrementale" },;
{ "Key", "Clave", "Cl�", "Chave","Schl�ssel","Chiave" },;
{ "Help", "Ayuda", "Aide", "Ajuda","Hilfe","Aiuto" },;
{ "Import/Export for ", "Importar/Exportar para ", "Importer/Exporter vers ", "Importar/Exportar para ","Import/Export f�r ","Importa/Esporta per" },;
{ "PDF files | *.pdf |", "ficheros PDF | *.pdf |", "fichier PDF | *.pdf |", "arquivos PDF | *.pdf |","PDF-Dateien | *.pdf |","File PDF | *.pdf |", "archivi PDF | *.pdf |" },;
{ "Select PDF File to Save", "Seleccione el fichero PDF a guardar", "Choisissez un fichier PDF pour sauvegarder", "Selecione um arquivo PDF para salvar","PDF-Datei zum Speichern ausw�hlen","Seleziona il file pdf da salvare" },;
{ "Alert", "Alerta", "Alerte", "Alerta","Auswahl","Avviso" },;
{ "Select an option", "Seleccione una opci�n", "Choisissez une option", "Selecione uma op��o","W�hle eine Option","Seleziona una opzione" },;
{ "Window", "Ventana", "Fen�tre", "Janela", "Fenster","Finestra" },;
{ "Tile Vertical", "Distribuci�n vertical", "Mosa�que verticale", "Organizar verticalmente","Vertikal anordnen","Titolo verticale" },;
{ "Vertical arranges the windows as nonoverlapping tiles", "Organiza las ventanas verticalmente", "Organise les fen�tres verticalement", "Organiza as janelas verticalemente","Vertikal anordnen (nicht �berlappend)","Organizza verticalmente le finestre" },;
{ "Tile Horizontal", "Distribuci�n horizontal", "Mosa�que horizontale", "Organizar horizontalmente","Horizontal anordnen","Distribuzione orizzontale" },;
{ "Horizontal arranges the windows as nonoverlapping tiles", "Organiza las ventanas horizontalmente", "Mosa�que horizontale sans superposition", "Organizar as janelas horizontalmentesem superposi��o","Horizontal anordnen (nicht �berlappend)","Organizza orizzontalmente le finestre" },;
{ "Cascade", "Cascada", "Cascade", "Cascata","Kaskadierend","A cascata" },;
{ "Arranges the windows so they overlap", "Organiza las ventanas para que no se oculten", "Organiser les fen�tres pour qu�elles ne se superposent pas", "Organiza as janelas para que n�o se sobreponham","Fenster anordnen (�berlappend)","Organizza le finestre affinch� non si sovrappongano" },;
{ "Next Window", "Pr�xima ventana", "Fen�tre suivante", "Pr�xima janela","N�chstes Fenster","Finestra successiva" },;
{ "File to Save", "Fichero a guardar", "fichier pour sauvegarder", "arquivo para salvar","Datei zum Speichern ausw�hlen", "file da salvare" },;
{ "Selects the next window", "Selecciona la pr�xima ventana", "Selectionne la fen�tre suivante", "Selecione a pr�xima janela","N�chstes Fenster ausw�hlen","Seleziona la prossima finestra" },;
{ "Arrange Icons", "Organiza los iconos", "Organise les ic�nes", "Organiza os �cones","Icons anordnen","Disponi icone" },;
{ "Arrange icons at the bottom of the window", "Organiza los iconos al final de la ventana", "Organiser les ic�nes au pied de la fen�tre", "Organizar os �cones no p� da janela","Icons am unteren Rand anordnen","Organizza le icone in fondo alla finestra" },;
{ "Iconize All", "Iconiza todas", "Reduire toutes", "Iconizar todas","Alle verbergen","Riduci tutto ad icona" },;
{ "Iconize all open windows", "Iconiza todas las ventanas abiertas", "Reduire toutes les fen�tres ouvertes", "Iconizar todas as janelas abertas","Alle offenen Fenster verbergen","Riduci a icona tuttte le finestre aperte" },;
{ "Close", "Cierra", "Fermer", "Fechar", "Alle", "Chiudi" },;
{ "Close All", "Cierra todas", "Fermer toutes", "Fecha todas","Alle schlie�en","Chiudi tutto" },;
{ "Close all open windows", "Cierra todas las ventanas abiertas", "Fermer toutes les fen�tres ouvertes", "Fechar todas as janelas abertas","Alle offenen Fenster schlie�en","Chiudi tutte le finestre aperte" },;
{ "Contents", "Contenidos", "Contenu", "Conte�do","Inhalte","Contenuti" },;
{ "Show the help contents", "Muestra los contenidos de la ayuda", "Montrer le contenu de l�aide", "Mostrar o conte�do da ajuda","Hilfethemen","Mostra i contenuti del file di aiuto" },;
{ "Search for Help on...", "Busca en la ayuda por...", "Rechecher de l�aide sur", "Procurar ajuda para","Suche f�r Hilfe �ber...","Ricerca nel file di help per..." },;
{ "Search the help for a specific item", "Busca la ayuda para un item espec�fico", "Rechecher de l�aide sur un sujet sp�cifique", "Procurar ajuda para um �tem esp�cifico","Suche f�r Hilfe �ber ein bestimmtes Thema","Ricerca nel file di help per una specifica parola" },;
{ "Using help", "Usando la ayuda", "Utilisant l�aide", "Usando a ajuda","Hilfe benutzen","Uso dell'help" },;
{ "Show the help index", "Muestra el �ndice de la ayuda", "Montrer le catalogue de l�aide", "Mostrar o �ndice da ajuda","Hilfeindex zeigen","Mostra l'indice del file di help" },;
{ "About...", "Acerca de...", "Sur...", "A respeito de...", "�ber...","Circa..." },;
{ "Displays program information and copyright", "Muestra informaci�n y derechos de copia del programa", "Afficher les informations et droits du programme", "Exibir os direitos e informa��es do programa","Copyright und Information","Mostra informazioni e copyright del programma" },;
{ "Default RDD", "RDD por defecto", "RDD par d�faut", "RDD padr�o","Standard f�r Datenbanktreiber","RDD standard" },;
{ "Open in shared mode", "Abrir en modo compartido", "Ouvrir en mode partag�", "Abrir em modo compartilhado","�ffnen f�r gemeinsamen Zugriff","Apri in modalit� condivisa" },;
{ "No Help file defined with SetHelpFile()", "No se ha definido un fichero de ayuda usando SetHelpFile()", "Aucun fichier d�aide d�fini avec la fonction SetHelpFile()", "N�u foi definido um arquivo de ajuda usando SetHelpFile()","Keine Hilfe definiert mit SetHelpFile()","Nessun file di help definito con SetHelpFile()" },;
{ "Want to delete this record ?", "� Desea eliminar este registro ?", "Supprimer cet enregistrment?", "Eliminar este registro?","Diesen Datensatz l�schen?","Vuoi cancellare questo record ?" },;
{ "Expression builder", "Constructor de expresiones", "G�n�rateur d�expression", "Construtor de express�es","Ausdr�cke definieren","Costruzione espressione" },;
{ "Operators", "Operadores", "Operateurs", "Operadores" ,"Operatoren","Operatori" },;
{ "Functions", "Funciones", "Fonctions", "Fun��es","Funktionen","Funzioni" },;
{ "Relations of", "Relaciones de", "Relations de", "Rela��es de","Relationen","Relazioni" },;
{ "Rel.", "Rel.", "Rel.", "Rel.","Rel.","Rel." },;
{ "Child Alias", "Alias del hijo", "Alias du fils", "Alias do filho","Kind-Alias","Aree figlio" },;
{ "Additive", "Aditivo", "Additif", "Aditivo","Zus�tzlich","Aggiuntive" },;
{ "Scoped", "Con �mbito", "Encadr�", "Com �mbito","Sichtbar","Portata" },;
{ "Processes", "Procesos", "Processus", "Processos","Prozesse","Processi" },;
{ "Run", "Ejecutar", "Executer", "Executar","Ausf�hren","Esegui" },;
{ "DELETED", "BORRADO", "SUPPRIM�", "EXCLUIDO","GEL�SCHT","CANCELLATO" },;
{ "Record updated", "Registro actualizado", "Enregistrement actualis�", "Registro atualizado","Datensatz aktualisiert","record modificato" },;
{ "DBF builder", "Constructor de DBF", "G�n�rateur de DBF", "Construtor de DBF","DBF definieren und erzeugen","Costruzione DBF" },;
{ "Field Name", "Nombre campo", "Nom champ", "Nome campo","Feldname","Nome campo" },;
{ "FieldName", "Nombre campo", "Nom champ", "Nome campo","Feldname","Nome campo" },;
{ "Move Up", "Mover arriba", "D�placer vers le haut", "Mover para cima","Aufw�rts bewegen","Muovi in su" },;
{ "Move Down", "Mover abajo", "D�placer vers le bas", "Mover para cima" ,"Abw�rts bewegen","Muovi in giu" },;
{ "DBF Name:", "Nombre DBF:", "Nom DBF:", "Nome DBF:","DBF-Name:","Nome DBF" },;
{ "Language", "Lenguaje", "Idiome", "Idioma" ,"Sprache","Linguaggio" },;
{ "English", "Ingl�s", "Fran�ais", "Portugu�s","Englisch","Inglese" },;
{ "Spanish", "Espa�ol", "Espagnol", "Espanhol","Spanisch","Spagnolo" },;
{ "French", "Frances", "Fran�ais", "Franc�s","Franz�sisch","Francese" },;
{ "German", "Alem�n", "Allemand", "Alem�o","Deutsch","Tedesco" },;
{ "Portuguese", "Portugues", "Portugais", "Portugu�s","Portugiesisch","Portoghese" },;
{ "Italian", "Italiano", "Italien", "Italiano","Italienisch","Italiano" },;
{ "Databases", "Bases de datos", "Base de donn�es", "Base de dados","Datenbanken","Database" },;
{ "Query", "Consulta", "Requ�te", "Consulta","Abfrage","Richiesta" },;
{ "Query builder", "Constructor de consultas", "G�n�rateur de requ�tes", "Construtor de consultas","Abfrage definieren","Contruzione richiesta" },;
{ "Operation", "Operaci�n", "Operation", "Opera��o","Operation","Operazione" },;
{ "Equal", "Igual", "�gal", "Igual","Gleich","Uguale" },;
{ "Different", "Diferente", "Different", "Diferente","Verschieden","differenre" },;
{ "Like", "Como", "Comme", "Como","Wie","Simile" },;
{ "Equal", "Igual", "�gal", "Igual","Gleich","Uguale" },;
{ "Select a table", "Seleccionar una tabla", "Choisir un tableau", "Selecionar uma tabela","W�hle eine Tabelle","Selezona una tabella" },;
{ "Delete for", "Borrar por", "Supprimer si", "Excluir se","L�sche wenn","Cancella per" },;
{ "Delete records of", "Borrar registros de", "Supprimer enregistrements de", "Excluir registros de","L�sche Datens�tze mit","Cancella records per" },;
{ "For condition", "Condici�n para", "Condition SI", "Condi��o SE","Bedingung","Condizione per" },;
{ "While condition", "Condici�n mientras", "Condition pendant", "Condi��o enquanto","Solange","Condizione finch�" },;
{ "Total deleted", "Borrados en total", "Total supprim�s", "Total exclu�dos","Insgesamt gel�scht","Tolale cancellati" },;
{ "Number of records", "N�mero de registros", "Quantit� d�enregistrements", "Quantidade de registros","Zahl der Datens�tze","Numero di records" },;
{ "Recall", "Recuperar", "R�cup�rer", "Recuperar","Wiederherstellen","Recupera" },;
{ "The string", "La cadena", "La cha�ne", "A cadeia","Das Wort","La stringa" },;
{ "for language", "para el idioma", "pour l�idiome", "para o idioma","f�r die Sprache","per il linguaggio" },;
{ "defined from", "definida en", "d�finie � partir de", "definida de","aufgerufen von","definita da" },;
{ "line", "l�nea", "ligne", "linha","Zeile","linea" },;
{ "is not defined in FWH strings", "no est� traducida en las cadenas de FWH", "non traduit dans les cha�nes de FWH", "n�o est� traduzida nas cadeias de FWH","ist in den FWH-Strings nicht definiert","Non � definita nelle stringhe FWH" },;
{ "Please add it to FWH\source\function\strings.prg",;
"Por favor incluir en FWH\source\function\strings.prg",;
"Ajouter s�il vouz plait dans FWH\source\function\strings.prg",;
"Bitte erg�nze es in FWH\source\function\strings.prg",;
"Pewr vavore caricatela nell'archivio FWH\source\function\strings.prg",;
"Please add it to FWH\source\function\strings.prg" },;
{ "freeimage.dll not found", "no se encuentra freeimage.dll", "manque freeimage.dll", "freeimage.dll n�o encontrada","Freeimage.dll nicht gefunden","freeimage.dll non trovata" },;
{ "file not found", "fichero no encontrado", "fichier pas trouv�", "arquivo n�o encontrado" ,"Datei nicht gefunden","Archivio non trovato"},;
{ "�", "�", "?", "?","?","?" },;
{ "Excel not installed", "No est� instalado Excel", "Excel non install�", "Excel n�o instalado","Excel nicht gefunden","Excel non installato" },;
{ "Could not set the format", "No puede establecerse el formato", "Il n�a pas �t� possible d��tablir le format", "N�o foi poss�vel estabelecer o formato","Kann das Format nicht festlegen","Non posso impostare il formato" },;
{ "No spreadsheet software installed",;
"No hay software instalado para visualizar hojas de c�lculo",;
"Il n�y a pas de programme install� por visualiser les feuilles de calcul",;
"N�o tem software instalado para visualizar as folhas de c�lculo","Keine Tabellekalkulationssoftware installiert","Nessun software di foglio elettronico installato" },;
{ "to column", "hasta la columna", "jusqu�� la colonne", "at� a coluna","nach Reihe","alla colonna" },;
{ "to excel", "a excel", "vers excel", "para excel","nach Excel","in excel" },;
{ "to calc", "a hoja de c�lculo", "vers feuille de calcul", "para folha de c�lculo","nach Calc","in calcolo" },;
{ "to dbf", "a la DBF", "vers DBF", "para DBF","nach DBF","in dbf" },;
{ "Please select a database", "Por favor seleccione una base de datos", "S�il vous plait choisissez une base de donn�es", "Por favor selecione uma base de dados","Bitte w�hle eine Datenbank","Seleziona un database" },;
{ "DBF file| *.dbf|Access file| *.mdb|Access 2010 file | *.accdb|SQLite file| *.db|",;
"Fichero DBF| *.dbf|Fichero Access| *.mdb|Fichero Access 2010| *.accdb|Fichero SQLite| *.db|",;
"Fichier DBF| *.dbf|Fichier Access| *.mdb|Fichier Access 2010| *.accdb|Fichier SQLite| *.db|",;
"Arquivo DBF| *.dbf|Arquivo Access| *.mdb|Arquivo Access 2010| *.accdb|Arquivo SQLite| *.db|",;
"DBF Datenbank| *.dbf|Access Datenbank| *.mdb|Access 2010 Datenbank| *.accdb|SQLite Datenbank| *.db|",;
"File DBF| *.dbf|File Access| *.mdb|File Access 2010 |*.accdb|SQLite file| *.db|" },;
{ "Excel", "Excel", "Excel", "Excel", "Excel" },;
{ "Select", "Seleccione", "S�lectionner", "Selecionar", "W�hlen", "Selezionare" },;
{ "Modify DBF structure", "Modificar estructura DBF", "Changement structure DBF", "Alterar estrutura do DBF", "DBF-Struktur bearbeiten", "Modifica struttura DBF" },;
{ "Locate and open a file", "Localizar y abrir un fichero", "Trouver et ouvrir un fichier", "Localizar e abrir um arquivo", "Datei ausw�hlen und �ffnen", "Selezionare e aprire un file" },;
{ "Create a new file in a new edit window", "Crear un nuevo fichero en una nueva ventana de edici�n","Creer un nouveau fichier dans une nouvelle fenetre", "Criar um novo arquivo em uma nova janela de edi��o", "Neue Datei in einem neuen Fenster", "Creare un nuovo file in una nuova finestra di modifica" },;
{ "Save the current file", "Guardar el fichero actual", "Sauvegarder le fichier courant", "Salvar o arquivo Atual", "Aktuelle Datei speichern", "Salvare il file corrente" },;
{ "Close the current file", "Cerrar el fichero actual", "Fermer le fichier courant", "Fechar o arquivo Atual", "Aktuelle Datei schlie�en", "Chiudere il file corrente" },;
{ "Print the current file", "Imprimir el fichero actual", "Imprimer le fichier courant", "Imprimir o arquivo Atual", "Aktuelle Datei drucken", "Stampare il file corrente" },;
{ "Exit this app", "Salir de esta aplicaci�n", "Quitter cette application", "Sair da aplica��o", "Programm beenden", "Uscire da questa applicazione" },;
{ "Project", "Proyecto", "Projet", "Projeto", "Projekt", "Progetto" },;
{ "Open project", "Abrir proyecto", "Ouvrir projet", "Abrir projeto", "Projekt �ffnen", "Aprire il progetto" },;
{ "Save project", "Guardar proyecto", "Sauvegarder projet", "Salvar projeto", "Projekt speichern", "Salvare il progetto" }, ;
{ "Printer setup", "Configurar la impresora", "Configuration Imprimante", "Configurar a impressora", "Drucker ausw�hlen", "Configurare la stampante" },;
{ "Change directory", "Cambiar de directorio", "Changer de dossier", "Trocar diret�rio", "Wechsle Verzeichnis", "Cambiare directory" },;
{ "Close project", "Cerrar proyecto", "Fermer projet", "Fechar o projeto", "Schlie�e Projekt", "Chiudere il progetto" },;
{ "Add item", "A�adir item", "Ajouter �l�ment", "Adicionar item", "Element hinzuf�gen", "Aggiungere un elemento" },;
{ "Delete item", "Borrar item", "Supprimer �l�ment", "Apagar item", "Element l�schen", "Cancellare un elemento" },;
{ "Open this project", "Abrir este proyecto", "Ouvrir ce projet", "Abrir este projeto", "Dieses Projekt �ffnen", "Aprire questo progetto" },;
{ "Undo the previous editor action", "Deshacer la acci�n previa del editor", "Annuler l'action pr�c�dente de l'�diteur", "Desfazer a a��o do editor", "Undo der letzten Aktion", "Annullare l'ultima operazione di modifica" },;
{ "Redo the previous undo editor action", "Repetir la acci�n de deshacer previa del editor","R�peter l'action pr�c�dente de l'�diteur", "Repetir a a��o de desfazer do editor", "Redo der letzten Undo-Aktion", "Ripetere l'ultima operazione di modifica annullata" },;
{ "Remove the selected text and put it on the clipboard","Quitar el texto seleccionado y ponerlo en el portapapeles", "Effacer le texte s�lectionn� et le copier dans le presse-papier", "Remover o texto e colocar no porta pap�is", "Markierten Text entfernen und in die Zwischenablage kopieren", "Eliminare il testo selezionato e metterlo negli appunti" },;
{ "Copy the selected text to the clipboard", "Copiar el texto seleccionado al portapapeles","Copier le texte s�lectionn� dans le presse-papier", "Copiar o texto selecionado e colocar no porta pap�is", "Markierten Text in die Zwischenablage kopieren", "Copiare il testo selezionato negli appunti" },;
{ "Insert text from the clipboard at the current position","Insertar texto del portapapeles en la posici�n actual", "Ins�rer texte du presse-papier � la position courante", "Inserir texto do porta pap�is na posi��o atual", "F�ge den Text aus der Zwischenablage an der aktuellen Position ein", "Inserire il testo dagli appunti nella posizione corrente" }, ;
{ "Select all text in the editor", "Seleccionar todo el texto del editor", "S�lectionner tout le texte de l'�diteur", "Selecionar todo o texto do editor", "Alles markieren", "Selezionare tutto il testo nell'editor" },;
{ "Line duplicate", "Duplicar l�nea", "Dupliquer ligne", "Duplicar linha", "Kopie der Zeile", "Duplicare una linea" },;
{ "Duplicate line actual", "Duplicar la l�nea actual", "Dupliquer ligne actuelle", "Duplicar linha atual", "Aktuelle Zeile kopieren", "Duplicare la linea corrente" },;
{ "Search for text", "Buscar texto", "Chercher un texte", "Procurar texto", "Nach Text suchen", "Cercare un testo" }, ;
{ "Find next", "Buscar siguiente", "Trouver suivant", "Procurar seguinte", "Nach unten suchen", "Cercare il prossimo" },;
{ "Find next occurrence", "Buscar la siguiente ocurrencia", "Trouver l'occurence suivante", "Procurar a seguinte ocorr�ncia", "N�chstes Vorkommen", "Cercare la prossima occorrenza" },;
{ "Find prev", "Buscar previo", "Trouver pr�c�dent", "Procurar pr�via", "Nach oben suchen", "Cercare il precedente" },;
{ "Find", "Buscar", "Trouver", "Procurar", "Suchen", "Cercare" },;
{ "Find previous occurrence", "Buscar la ocurrencia previa", "Trouver l'occurence pr�c�dente", "Procurar ocorr�ncia pr�via", "Vorhergehendes Vorkommen", "Cercare l'occorrenza precedente" },;
{ "Search again", "Buscar de nuevo", "Chercher de nouveau", "Procurar de novo", "Erneut suchen", "Cercare ancora" },;
{ "Repeat the last search or repeat operation", "Repetir la �ltima b�squeda � repetir la operaci�n", "R�peter la derni�re recherche ou r�peter l'op�ration", "Repetir a �ltima procura e repetir a opera��o", "Wiederhole die letzte Suche oder Aktion", "Ripetere l'ultima ricerca o ripetere l'operazione" },;
{ "Goto line number", "Ir a la l�nea n�mero", "Aller � la ligne num�ro", "Ir para a linha n�mero", "Gehe zur Zeilennummer", "Andare alla linea numero" },;
{ "Replace", "Reemplazar", "Remplacer", "Substituir", "Ersetzen", "Sostituire" },;
{ "Repeat the last search or repeat operation", "Repetir la �ltima b�squeda � repetir la operaci�n", "R�peter la derni�re recherche ou r�peter l'op�ration", "Repetir a �ltima procura e repetir a opera��o", "Wiederhole die letzte Suche oder Aktion", "Ripetere l'ultima ricerca o ripetere l'operazione" },;
{ "Go to line number", "Ir a la l�nea n�mero", "Aller � la ligne num�ro", "Ir para a linha n�mero", "Gehe zur Zeilennummer", "Andare alla linea numero" },;
{ "Move cursor to a specific line number", "Mover el cursor a un n�mero de l�nea espec�fico", "D�placer le curseur vers une ligne sp�cifique", "Mover o cursor para a linha", "Gehe mit dem Cursor zu einer bestimmten Zeilennummer", "Spostare il cursore ad un numero di linea specifico" },;
{ "Run as script", "Ejecutar como script", "Executer comme un script", "Executar como script", "Ausf�hren als Skript", "Eseguire come script" },;
{ "Run the current program as a script without building an EXE", "Ejecutar el programa actual como un script sin construir un EXE", "Executer le programme actuel comme un script sans construire un exe", "Executar o programa atual como script sem construir um EXE", "Ausf�hren des aktuellen Programmes als Skript ohne eine EXE zu erzeugen", "Eseguire il programma corrente come script senza generare l'EXE" },;
{ "Run as .EXE", "Ejecutar como .EXE", "Executer comme un Exe", "Executar como EXE", "Ausf�hren als EXE", "Eseguire come EXE" },;
{ "Build and run as an EXE", "Construir y ejecutar como un EXE", "Construire et executer comme un Exe", "Construir e executar como EXE", "Erzeugen und Ausf�hren als EXE", "Generare ed eseguire come EXE" },;
{ "Debug", "Depurar", "D�bugger", "Depurar", "Austesten", "Debug" },;
{ "Debug the EXE", "Depurar el EXE", "D�bugger l'exe", "Depurar o EXE", "Austesten der EXE", "Eseguire il debug dell'EXE" },;
{ "Arguments", "Argumentos", "Arguments", "Argumentos", "Argument", "Argomenti" },;
{ "Tools", "Herramientas", "Outils", "Ferramentas", "Werkzeuge", "Strumenti" },;
{ "Cmd Window", "Ventana Cmd", "Fenetre de Commandes", "Prompt de comando", "Eingabeaufforderung", "Finestra Cmd" },;
{ "Settings", "Configuraciones", "Configuration", "Configura��es", "Einstellungen", "Impostazioni" },;
{ "Configure this menu", "Configurar este men�", "Configurer ce menu", "Configurar este menu", "Konfigurieren dieses Men�", "Configurare questo menu" },;
{ "Project panel", "Panel del proyecto", "Panel de projet", "Painel do projeto", "Projektfenster", "Pannello del progetto" },;
{ "Result panel", "Panel de resultado", "Panel de r�sultat", "Painel de resultado", "Ergebnisfenster", "Pannello del risultato" },;
{ "Functions panel", "Panel de funciones", "Panel de fonctions", "Painel de fun��es", "Funktionsfenster", "Pannello delle funzioni" },;
{ "Preferences", "Preferencias", "Pr�f�rences", "Prefer�ncias", "Bevorzugte Einstellungen", "Preferenze" },;
{ "FiveTech source code editor", "Editor de c�digo fuente de FiveTech", "Editeur de code source Fivetech", "Editor de c�digo fonte da FiveTech", "FiveTech Quellcode-Editor", "Editor di codice sorgente della FiveTech" },;
{ "Run as script", "Ejecutar como script", "Executer comme un script", "Executar como script", "Ausf�hren als Skript", "Eseguire come script" },;
{ "Build and execute", "Construir y ejecutar", "Construire et executer", "Construir e executar", "Erzeugen und Ausf�hren", "Generare ed eseguire" },;
{ "Build and execute with debugger", "Construir y ejecutar con depurador", "Construire et executer avec d�bugger", "Construir e executar com depurador", "Erzeugen und Ausf�hren mit Austesten", "Generare ed eseguire con il debugger" },;
{ "Debug", "Depurar", "Debug", "Depurar", "Austesten", "Debug" },;
{ "Find previous", "Encontrar el previo", "Trouver pr�c�dent", "Procurar pr�via", "Nach oben suchen", "Cercare il precedente" },;
{ "Replace", "Reemplazar", "Remplacer", "Substituir", "Ersetzen", "Sostituire" },;
{ "Goto line", "Ir a la l�nea", "Aller � la ligne", "Ir para a linha", "Gehe zu Zeile", "Andare alla linea" },;
{ "GotoLine", "Ir a la l�nea", "Aller � la ligne", "Ir para a linha", "Gehe zu Zeile", "Andare alla linea" },;
{ "Source code editor and projects manager", "Editor de c�digo fuente y gestor de proyectos", "Editeur de code et gestionnaire de projets", "Editor de c�digo fonte e gerenciador de projetos", "Quellcode-Editor und Projekt-Manager", "Editor di codice sorgente e gestione progetto" },;
{ "Repeat the last search or repeat option", "Repetir la �ltima b�squeda � repetir opci�n", "R�peter la derni�re recherche ou r�peter l'option", "Repetir �ltima busca e repetir op��o", "Wiederhole die letzte Suche oder Aktion", "Ripetere l'ultima ricerca o ripetere l'opzione" },;
{ "Row", "Fila", "Ligne", "Linha", "Reihe", "Riga" },;
{ "Col", "Col", "Colonne", "Coluna", "Spalte", "Colonna" },;
{ "C compiler", "Compilador de C", "Compilateur de C", "Compilador C", "C Compiler", "Compilatore C" },;
{ "general", "general", "general", "geral", "allgemein", "generale" },;
{ "Command line parameters", "Par�metros de la l�nea de comando", "Param�tre de ligne de commandes", "Par�metros da linha de comando", "Kommandozeilen-Parameter", "Parametri della linea di comando" },;
{ "Program file", "Fichero de programa", "Fichier de programmes", "Arquivo de programa", "Programmdatei", "File del programma" },;
{ "Header file", "Fichero de cabecera", "Fichier ent�te", "Arquivo de cabe�alho", "Headerdatei", "File di intestazione" },;
{ "Resource file", "Fichero de recursos", "Fichier ressources", "Arquivo de recursos", "Resourecedatei", "File di risorse" },;
{ "Open any file", "Abrir cualquier fichero", "Ouvrir un fichier quelconque", "Abrir qualquer arquivo", "�ffne eine Datei", "Aprire qualunque tipo di file" },;
{ "Select a file to open", "Seleccionar el fichero a abrir", "S�lectionner un fichier pour ouverture", "Selecionar um arquivo para abrir", "W�hle eine Datei zum �ffnen aus", "Scegliere un file da aprire" },;
{ "Tools settings", "Configuraci�n de herramientas", "Configuration outils", "Configurar ferramentas", "Werkzeugeinstellungen", "Configurare gli strumenti" },;
{ "This", "Esto", "Ce", "Este", "Diese", "Questo" },;
{ "Forward", "Hacia adelante", "Avancer", "Avan�ar", "Vorw�rts", "Avanti" },;
{ "Save the changes ?", "� Guardar los cambios ?", "Sauvegarder les changements ?", "Salvar as altera��es?", "Die �nderungen speichern ?", "Salvare le modifiche?" },;
{ "File has changed", "El fichero ha cambiado", "Le fichier a chang�", "Arquivo modificado", "Die Datei wurde ge�ndert", "Il file � stato modificato" },;
{ "With", "Con", "Avec", "Com", "Mit", "Con" },;
{ "Number", "N�mero", "Numero", "N�mero", "Nummer", "Numero" },;
{ "Source editor", "Editor de c�digo", "Editeur code sources", "Editor de c�digo", "Quellcode-Editor", "Editor di codice sorgente" },;
{ "Script error at line", "Error en el script en la l�nea", "Erreur de script � la ligne", "Erro de script na linha:", "Skriptfehler in Zeile", "Errore nello script alla linea" },;
{ "Project filename", "Nombre de fichero del proyecto", "Nom du fichier du projet", "Nome do arquivo de projeto", "Name der Projektdatei", "Nome file del progetto" },;
{ "is missing", "no se encuentra", "pas trouv�", "N�o encontrado", "fehlt", "non trovato" },;
{ "Code separator", "Separador de c�digo", "S�parateur de code", "Separador de C�digo", "Code Trennzeile", "Separatore di codice" },;
{ "Insert a code separator", "Inserta un separador de c�digo", "Ins�rer un code s�parateur", "Insira um separador de C�digo", "Code Trennzeile einf�gen", "Inserisce un separatore di codice" },;
{ "Search for", "Buscar por", "Chercher", "Procurar por", "Suchen nach", "Cerca" },;
{ "WildSeek", "Busqueda libre", "Recherche �tendue", "Busca livre", "Freie Suche", "Ricerca libera" },;
{ "Copy and paste in", "Copie y pegue en", "Copier et Coller dans", "Copiar e colar em", "Kopieren und Einf�gen in", "Copiare e incollare in" },;
{ "There are no printers installed!", "�No hay impresoras instaladas!", "Pas d'imprimante install�e", "N�o tem impressoras instaladas", "Es sind keine Drucker installiert !", "Nessuna stampante installata" },;
{ "Please exit this application and install a printer", "Por favor salga de la aplicaci�n e instale una impresora", "Veuillez quitter cette application et installer une imprimante", "Por favor, saia desta aplica��o e instale uma impressora", "Bitte schlie�en Sie das Programm und installieren Sie einen Drucker", "Uscire dall'applicazione e installare una stampante" },;
{ "The temporal metafile could not be created", "El metafile temporal no pudo ser creado", "Impossible de cr�er le fichier metafile", "Metafile temporal, n�o p�de ser criado", "Die tempor�re Meta-Datei konnte nicht erzeugt werden", "Impossibile creare il metafile temporaneo" },;
{ "Printer object Error", "Error objeto impresora", "Erreur Objet Imprimante", "Erro de Objeto da impressora", "Druckerobject-Fehler", "Errore nell'oggetto stampante" },;
{ "Could not create temporary file", "No se pudo crear el fichero temporal", "Ne peut pas cr�er fichier temporaire", "N�o foi poss�vel criar o arquivo tempor�rio", "Die tempor�re Datei konnte nicht erzeugt werden", "Impossibile creare il file temporaneo" },;
{ "Please check your free space on your hard drive", "Por favor compruebe el espacio libre en su disco duro", "Controler l'espace disponible de votre disque dur ", "Por favor, verifique o espa�o livre no disco r�gido(HD)", "Bitte �berpr�fen Sie den freien Speicherplatz auf Ihrem Festplattenlaufwerk", "Controllare lo spazio disponibile sul disco fisso" },;
{ "and the amount of files handles available.", "y la cantidad de manejadores de ficheros disponibles", "et la quantit� de fichiers handle disponible", "e a quantidade de arquivos dispon�veis", "und den Wert der m�glichen, offenen Dateien", "e i file handle disponibili" },;
{ "Print preview error", "Error del previsualizador de impresi�n", "Erreur Visualisation Impression", "Erro de pr�-visualiza��o da impress�o", "Druckvorschau-Fehler", "Errore nell'anteprima di stampa" } }

static aMissing := {}

//----------------------------------------------------------------------------//

function FWString( cString )

   local nAt
     
   if FWLanguageID() == 1
      return cString
   elseif ( nAt := AScan( aStrings, { | aString | Upper( aString[ 1 ] ) == Upper( cString ) } ) ) != 0
      if Len( aStrings[ nAt ] ) >= FWLanguageID()
         return IfNil( aStrings[ nAt ][ FWLanguageID() ], cString )
      endif
   else
      if '&' $ cString
         cString  := StrTran( cString, '&', '' )
         if ( nAt := AScan( aStrings, { | aString | Upper( aString[ 1 ] ) == Upper( cString ) } ) ) != 0
            if Len( aStrings[ nAt ] ) >= FWLanguageID()
               return '&' + IfNil( aStrings[ nAt ][ FWLanguageID() ], cString )
            endif   
         endif
      endif
      MsgInfo( "The string" + ': "' + cString + '" ' + ;
               "for language" + " " + ;
               { "EN", "ES", "FR", "PT", "DE", "IT" }[ FWLanguageID() ] + CRLF + ;
               "defined from" + ": " + ProcName( 1 ) + " " + ;
               "line" + " " + ;
               AllTrim( Str( ProcLine( 1 ) ) ) + " in " + ProcFile( 1 ) + CRLF + ;
               "is not defined in FMC strings" + CRLF + ;
               "Please add it to fivemac/source/function/strings.prg" )
      AAdd( aMissing, cString )
   endif
  
return cString

//----------------------------------------------------------------------------//

function FWSetLanguage( nNewLanguage )

   local nOldLanguage := FWLanguageID()

   if ! Empty( nNewLanguage )
      nLanguage = Max( 1, Min( nNewLanguage, Len( aStrings[ 1 ] ) ) )
   endif   

return nOldLanguage

//----------------------------------------------------------------------------//
/*
function FWAddLanguage( aLang, nLang )

   if ValType( aLang ) == 'A' .and. ! Empty( aLang )
      aStrings    := ArrTranspose( aStrings )
      if nLang == nil .or. nLang > Len( aStrings )
         AAdd( aStrings, aLang )
         nLang := Len( aStrings )
      else
         aStrings[ nLang ] := aLang
      endif
      aStrings    := ArrTranspose( aStrings )
      FWSetLanguage( nLang )
   endif

return nLang
*/

//----------------------------------------------------------------------------//

function FWMissingStrings()

   local cResult := ""

   AEval( aMissing, { | cString | cResult += Space( 7 ) + '{ "' + cString + ;
                                  '", "" },;' + CRLF } )
   if ! Empty( cResult )
         FM_MemoEdit( cResult, FWString( "Copy and paste in" ) + ;
         		 " FWH\source\function\strings.prg" )
   endif

return cResult

//----------------------------------------------------------------------------//

function FWAddString( aString )

return AAdd( aStrings, aString )

//----------------------------------------------------------------------------//

function FWLanguageID()

   if Empty( nLanguage )
      nLanguage   = Max( 1, AScan( { "EN", "ES", "FR", "PT", "DE", "IT" },;
                        Upper( Left( HB_LangSelect(), 2 ) ) ) )
   endif

return nLanguage

//----------------------------------------------------------------------------//

function FWSetDefaultLanguage()
    
    local cLanguage:= DefaultLanguage()
    
    if Empty( nLanguage )
        nLanguage   = Max( 1, AScan( { "EN", "ES", "FR", "PT", "DE", "IT" },;
                                    Upper( Left( cLanguage, 2 ) ) ) )
    endif
    
    FWSetLanguage( nLanguage )
    
return nLanguage

//----------------------------------------------------------------------------//

function DefaultLanguage()
    
return GetCurrentLanguage()

//----------------------------------------------------------------------------//
/*
function FWLoadStrings( cFileName )

   local cLine, n := 1

   DEFAULT cFileName := cFilePath( GetModuleFileName( GetInstance() ) ) + ;
                        "fwstrings.ini"
   
   while ! Empty( cLine := GetPvProfString( "strings", AllTrim( Str( n++ ) ), "", cFileName ) )
      AAdd( aStrings, { AllTrim( StrToken( cLine, 1, "|" ) ),;
                        AllTrim( StrToken( cLine, 2, "|" ) ),;
                        AllTrim( StrToken( cLine, 3, "|" ) ),;
                        AllTrim( StrToken( cLine, 4, "|" ) ),;
                        AllTrim( StrToken( cLine, 5, "|" ) ),;
                        AllTrim( StrToken( cLine, 6, "|" ) ) } )
   end
   
return nil                            
*/
//----------------------------------------------------------------------------//
/*
function FWSaveStrings( cFileName )

   local cText := "[strings]" + CRLF, n

   DEFAULT cFileName := cFilePath( GetModuleFileName( GetInstance() ) ) + ;
                        "fwstrings.ini"

   for n = 1 to Len( aStrings )
      cText += AllTrim( Str( n ) ) + "="
      AEval( aStrings[ n ], { | c | cText += If( c != nil, c, "" ) + "|" } )
      cText += CRLF
   next
   
return nil
*/
//----------------------------------------------------------------------------//
/*
function FWEditStrings()

   XBROWSER aStrings FASTEDIT AUTOSORT SETUP BrwSetup( oBrw )
   
return nil
*/
//----------------------------------------------------------------------------//  
/*
static function BrwSetUp( oBrw )

   oBrw:aCols[ 1 ]:cHeader = "English"
   oBrw:aCols[ 2 ]:cHeader = "Spanish"
   oBrw:aCols[ 3 ]:cHeader = "French"
   oBrw:aCols[ 4 ]:cHeader = "Portuguese"
   oBrw:aCols[ 5 ]:cHeader = "Italian"
   oBrw:aCols[ 6 ]:cHeader = "German"

   AEval( oBrw:aCols, { | oCol | oCol:nWidth := 200 } )

   ADD TO oBrw AT 1 DATA oBrw:BookMark HEADER " N� "

return nil 
*/
//----------------------------------------------------------------------------//           
