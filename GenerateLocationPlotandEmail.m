function GenerateLocationPlotandEmail(station_latitude,predicted_latitude,station_longitude,predicted_longitude,stn)

    %Should call the function to plot the graph tbh
      %Plotting between the two coordinates, with an annotated arrow.
      seismic_event_figure = figure(101);
      geoplot([station_latitude predicted_latitude],[station_longitude predicted_longitude],'r--p')
      geobasemap streets-light

      text(station_latitude,station_longitude,stn);
      text(predicted_latitude,predicted_longitude,"Event");
      %my_folder = 'C:\Users\Clayton\Documents\Imperial College Work\Year 4\FYP - Detecting Seismicity\code\Clayton-FYP'; %Change my folder as appropriate
      my_folder = fileparts(mfilename('fullpath'));

    % Check to make sure that folder actually exists.  Warn user if it doesn't.
    if ~isdir(my_folder)
      errorMessage = sprintf('Error: The following folder does not exist:\n%s', my_folder);
      uiwait(warndlg(errorMessage));
      return;
    end
    % Get a list of all files in the folder with the desired file name pattern.
    filePattern = fullfile(my_folder, '*.png'); % Change to whatever pattern you need.
    theFiles = dir(filePattern);
    for k = 1 : length(theFiles)
      baseFileName = theFiles(k).name;
      fullFileName = fullfile(my_folder, baseFileName);
      fprintf(1, 'Now deleting %s\n', fullFileName);
      delete(fullFileName);
    end
    
    
    file_name='seismic_event_location_plot.png';
 
    %Convert time_of_max_power to a real time.
    
    
    saveas(gcf,append('C:\Users\Clayton\Documents\Imperial College Work\Year 4\FYP - Detecting Seismicity\code\Clayton-FYP\',file_name));
     
    %Time to send an email alert.
    recipient_email = 'nichollsclayton2@gmail.com'; %Recipient
    sender_email = 'claytontestpython@gmail.com'; %Sender email Tutorial maybe
    sender_password = 'zkwsrmppralsonfw'; %Sender password
    
    
    setpref('Internet','E_mail',sender_email);  
    setpref('Internet','SMTP_Server','smtp.gmail.com');
    setpref('Internet','SMTP_Username',sender_email); %The sender.
    setpref('Internet','SMTP_Password',sender_password); %The sender password
    
    props = java.lang.System.getProperties;
    props.setProperty('mail.smtp.auth','true');
    props.setProperty('mail.smtp.starttls.enable','true');
    
    template_body =  "A seismic activity has been detected around coordinates: ";
    email_text_body = append(template_body,sprintf('%.2f',predicted_latitude)," ", sprintf('%.2f',predicted_longitude));
    saved_graph_location = append(my_folder,'\', file_name);
    sendmail('nichollsclayton2@gmail.com', 'Seismic activity alert!', email_text_body,saved_graph_location); 
