package com.gp.plantgardbackend.controller;

import com.gp.plantgardbackend.service.VideoService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.awt.image.BufferedImage;
import java.io.File;
import java.util.List;

@CrossOrigin(origins = "*", allowedHeaders = "*")
@RestController
public class UploadVideoController {

    @PostMapping ("/UploadVideo")
    public ResponseEntity<?>  UploadVideo(@RequestParam("file") MultipartFile file){
        if (file.isEmpty()) {
            return ResponseEntity.badRequest().body("Please select a video file to upload");
        }
        try {
            VideoService videoService = new VideoService();
            // Convert the MultipartFile to a File object
            File videoFile = videoService.convertMultipartFileToFile(file);

            // Split the video into frames
            List<BufferedImage> frames = videoService.splitVideoIntoFrames(videoFile);

            // Convert the frames to a byte array
            byte[][] frameBytes = videoService.convertFramesToByteArrays(frames);

            // Return the frames as a response
            return ResponseEntity.ok().body(frameBytes);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Failed to process video");
        }
    }

}
