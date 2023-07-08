package com.gp.plantgardbackend.service;

import org.opencv.core.Mat;
import org.opencv.videoio.VideoCapture;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.awt.image.DataBufferByte;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import static org.opencv.videoio.Videoio.*;
import org.opencv.videoio.VideoCapture;

@Service
public class VideoService {
    public File convertMultipartFileToFile(MultipartFile file) throws IOException {
        File convertedFile = new File(file.getOriginalFilename());
        FileOutputStream fos = new FileOutputStream(convertedFile);
        fos.write(file.getBytes());
        fos.close();
        return convertedFile;
    }

    public List<BufferedImage> splitVideoIntoFrames(File videoFile) throws Exception {
        List<BufferedImage> frames = new ArrayList<>();

        // Load the video file into OpenCV
        VideoCapture videoCapture = new VideoCapture(videoFile.getAbsolutePath());

        // Check if the video capture is successful
        if (!videoCapture.isOpened()) {
            throw new Exception("Failed to open video file");
        }

        // Get the video duration and frame rate
        int totalFrames = (int) videoCapture.get(CAP_PROP_FRAME_COUNT);
        double fps = videoCapture.get(CAP_PROP_FPS);
        double durationInSeconds = totalFrames / fps;

        // Calculate the number of frames to capture (one frame per second)
        int framesToCapture = (int) durationInSeconds;

        // Capture one frame per second and add it to the list
        for (int i = 0; i < framesToCapture; i++) {
            // Calculate the frame index to capture
            int frameIndex = (int) (i * fps);

            // Set the video capture position to the desired frame index
            videoCapture.set(CAP_PROP_POS_FRAMES, frameIndex);

            // Capture the frame and convert it to a BufferedImage
            Mat frame = new Mat();
            videoCapture.read(frame);
            BufferedImage bufferedImage = matToBufferedImage(frame);

            // Save the BufferedImage to a file on disk
            File frameFile = new File("frame_" + i + ".png");
            ImageIO.write(bufferedImage, "png", frameFile);

            // Add the frame to the list
            frames.add(bufferedImage);
        }

        // Release the video capture resources
        videoCapture.release();

        return frames;
    }

    public BufferedImage matToBufferedImage(Mat mat) {
        BufferedImage image = new BufferedImage(mat.width(), mat.height(), BufferedImage.TYPE_3BYTE_BGR);
        byte[] data = ((DataBufferByte) image.getRaster().getDataBuffer()).getData();
        mat.get(0, 0, data);
        return image;
    }

    public byte[][] convertFramesToByteArrays(List<BufferedImage> frames) throws IOException {
        byte[][] frameBytes = new byte[frames.size()][];

        for (int i = 0; i < frames.size(); i++) {
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            ImageIO.write(frames.get(i), "png", baos);
            frameBytes[i] = baos.toByteArray();
        }

        return frameBytes;
    }
}
