/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.business.util;

import static com.business.util.SFTPSendMyFiles.props;
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

public class SFTPGetMyFiles {

 static Properties props;

 public static void main(String[] args) {

  SFTPGetMyFiles getMyFiles = new SFTPGetMyFiles();
  if (args.length < 1)
  {
   System.err.println("Usage: java " + getMyFiles.getClass().getName()+
   " Properties_filename File_To_Download ");
   System.exit(1);
  }

  String propertiesFilename = args[0].trim();
  String fileToDownload = args[1].trim();
  getMyFiles.startFTP(propertiesFilename, fileToDownload);
   
 }

 public boolean startFTP(String propertiesFilename, String fileToDownload){

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

    String serverAddress = configuration.getProperty("serverAddress", null, "bancoMacro"); //props.getProperty("serverAddress").trim();
    String userId = configuration.getProperty("userId", null, "bancoMacro");  //props.getProperty("userId").trim();
    String password = configuration.getProperty("password", null, "bancoMacro");  //props.getProperty("password").trim();
    String remoteDirectory = configuration.getProperty("remoteDirectoryRequest", null, "bancoMacro");  //props.getProperty("remoteDirectory").trim();
    String localDirectory = configuration.getProperty("localDirectory", null, "bancoMacro");  //props.getProperty("localDirectory").trim();
   
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
     remoteDirectory + fileToDownload;
   
   // Create local file object
   String filepath = localDirectory +  fileToDownload;
   File file = new File(filepath);
   FileObject localFile = manager.resolveFile(file.getAbsolutePath());

   // Create remote file object
   FileObject remoteFile = manager.resolveFile(sftpUri, opts);

   // Copy local file to sftp server
   localFile.copyFrom(remoteFile, Selectors.SELECT_SELF);
   System.out.println("File download successful");

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