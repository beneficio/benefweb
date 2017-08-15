package com.business.util;

import java.io.File;
import java.io.FileInputStream;
import java.util.Properties;

import org.apache.commons.vfs2.FileObject;
import org.apache.commons.vfs2.FileSystemOptions;
import org.apache.commons.vfs2.Selectors;
import org.apache.commons.vfs2.impl.StandardFileSystemManager;
import org.apache.commons.vfs2.provider.sftp.SftpFileSystemConfigBuilder;
import org.jconfig.Configuration;
import org.jconfig.ConfigurationManager;
import org.jconfig.ConfigurationManagerException;
import org.jconfig.handler.XMLFileHandler;

public class SFTPSendMyFiles {

 static Properties props;

 public static void main(String[] args) {

  SFTPSendMyFiles sendMyFiles = new SFTPSendMyFiles();
  if (args.length < 1)
  {
   System.err.println("Usage: java " + sendMyFiles.getClass().getName()+
     " Properties_file File_To_FTP ");
   System.exit(1);
  }

  String propertiesFile = args[0].trim();
  String fileToFTP = args[1].trim();
  sendMyFiles.startFTP(propertiesFile, fileToFTP);

 }

 public boolean startFTP(String propertiesFilename, String fileToFTP){

props = new Properties();
StandardFileSystemManager manager = new StandardFileSystemManager();
ConfigurationManager configurationManager = null;
File configurationFile        = null;
XMLFileHandler xmlFileHandler = null;
Configuration configuration   = null;

  try {
        configurationManager = ConfigurationManager.getInstance();
        configurationFile = new File( propertiesFilename ); 
        xmlFileHandler = new XMLFileHandler(); 
        xmlFileHandler.setFile(configurationFile);
        try {
            configurationManager.load(xmlFileHandler, "bancoMacro");
        } catch(ConfigurationManagerException e) { 
            e.printStackTrace();
        }

        configuration = configurationManager.getConfiguration("bancoMacro");
      

//   props.load(new FileInputStream("properties/" + propertiesFilename));

    String serverAddress = configuration.getProperty("serverAddress", null, "bancoMacro") + ":" +
                           configuration.getProperty("port", null, "bancoMacro");
    String userId = configuration.getProperty("userId", null, "bancoMacro");  //props.getProperty("userId").trim();
    String password = configuration.getProperty("password", null, "bancoMacro");  //props.getProperty("password").trim();
    String remoteDirectory = configuration.getProperty("remoteDirectorySend", null, "bancoMacro");  //props.getProperty("remoteDirectory").trim();
    String localDirectory = configuration.getProperty("localDirectory", null, "bancoMacro");  //props.getProperty("localDirectory").trim();

   //check if the file exists
   String filepath = localDirectory +  fileToFTP;
   File file = new File(filepath);
   if (!file.exists())
    throw new RuntimeException("Error. Local file not found");

   //Initializes the file manager
   manager.init();

   //Setup our SFTP configuration
   FileSystemOptions opts = new FileSystemOptions();
   SftpFileSystemConfigBuilder.getInstance().setStrictHostKeyChecking(
     opts, "no");
   SftpFileSystemConfigBuilder.getInstance().setUserDirIsRoot(opts, true);
   SftpFileSystemConfigBuilder.getInstance().setTimeout(opts, 10000);

   //Create the SFTP URI using the host name, userid, password,  remote path and file name
   String sftpUri = "sftp://" + userId + ":" + password +  "@" + serverAddress + "/" + 
     remoteDirectory + fileToFTP;

System.out.println (sftpUri);   
   
System.out.println (file.getAbsolutePath());   
   // Create local file object
   FileObject localFile = manager.resolveFile(file.getAbsolutePath());

   // Create remote file object
   FileObject remoteFile = manager.resolveFile(sftpUri, opts);

   // Copy local file to sftp server
   remoteFile.copyFrom(localFile, Selectors.SELECT_SELF);
   System.out.println("File upload successful");

  }
  catch (Exception ex) {
   ex.printStackTrace();
   return false;
  }
  finally {
   manager.close();
  }

  return true;
 }


}