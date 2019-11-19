//
//  File.swift
//  diplomaiOS
//
//  Created by Mary Gerina on 10/1/19.
//  Copyright © 2019 Mary Gerina. All rights reserved.
//

import Foundation

struct OpenHelper {
    func open() {
        var sound = Sound(header: Header(length: 44), [Int]())
        var byte_arr = new byte[numberEntries];
        for (int i = 0; i < numberEntries; ++i)
        {
            byte_arr[i] = br.ReadByte();
        }
        NormalizationAndLatentPeriodsRemover.RemoveLatentPeriods(sound);
        NormalizationAndLatentPeriodsRemover.Normalization(sound);
        sound.countOfLines = sound.normalizationArr.Count / 256;
        Form1 form = (Form1)Application.OpenForms[0];
        form.trackBar1.Maximum = sound.countOfLines - 1;
        form.fourier = new FourierTransform(sound);
        form.fourier.InitFourierArray();
        form.walsch = new WalschTransform(sound);
        form.walsch.InitWalschArray();
        form.fourier.Draw(form.trackBar1.Value);
        form.representation = new LineRepresentation(sound, Convert.ToDouble(form.textBox1.Text));
        form.representation.initRepresentationFourier();
        form.representation.initRepresentationWalsch();
        form.representation.initRepresentationFourierSmoothing();
        form.representation.initRepresentationWalschSmoothing();
        if (form.уолшаToolStripMenuItem.Checked)
        {
            form.representation.DrawWalsch(form.trackBar2.Value);
            form.representation.DrawWalschSmoothing(form.trackBar2.Value);
            SaveToFileArray(sound, "walsch", path);
        }
        else
        {
            form.representation.DrawFourer(form.trackBar2.Value);
            form.representation.DrawFourerSmoothing(form.trackBar2.Value);
            SaveToFileArray(sound, "fourer", path);
        }
        form.sound = sound;
    }
}
