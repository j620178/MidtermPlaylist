//
//  ViewController.swift
//  MidtermPlaylist
//
//  Created by littlema on 2019/8/23.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let playlistProvider = PlaylistProvider()
    
    var playList: Playlist? {
        didSet {
            tableView.reloadData()
        }
    }

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            //tableView.delegate = self
            tableView.dataSource = self
            tableView.registerCellWithNib(identifier: SongTableViewCell.identifier, bundle: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        print("playlistProvider")
        
        playlistProvider.getToken(completion: { success in
            print(success)
        })
        
        playlistProvider.getPlaylist(offset: 0) { respones in
            print("123")
            switch respones {
            case .success(let playList):
                self.playList = playList
            case .failure(_):
                print("Error")
            }
        }
        
    }

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playList == nil ? 0 : playList!.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SongTableViewCell.identifier, for: indexPath)
        
        guard let playList = playList, let songCell = cell as? SongTableViewCell else { return cell }
        
        songCell.songImageView.image = UIImage(named: "600x600")
        songCell.songNameLabel.text = playList.data[indexPath.row].name
        
        return songCell
    }
    
    
}

